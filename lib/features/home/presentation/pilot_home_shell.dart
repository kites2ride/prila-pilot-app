import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:pilot/core/errors/app_failure.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/theme/theme_mode_controller.dart';
import 'package:pilot/core/widgets/fare_chip.dart';
import 'package:pilot/core/widgets/location_pair_tile.dart';
import 'package:pilot/core/widgets/prila_bottom_nav.dart';
import 'package:pilot/core/widgets/prila_card.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/core/widgets/settings_tile.dart';
import 'package:pilot/core/widgets/stat_tile.dart';
import 'package:pilot/features/auth/data/auth_repository.dart';
import 'package:pilot/features/location/location_update_strategy.dart';
import 'package:pilot/features/money/data/money_repository.dart';
import 'package:pilot/features/money/presentation/earnings_tab.dart';
import 'package:pilot/features/money/presentation/reviews_tab.dart';
import 'package:pilot/features/push/push_bootstrap.dart';
import 'package:pilot/features/rides/application/pilot_ride_session.dart';
import 'package:pilot/features/rides/data/ride_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pilot/features/push/data/devices_repository.dart';

final homeTodayEarningsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  return ref.watch(moneyRepositoryProvider).earnings('today');
});

class PilotHomeShell extends ConsumerStatefulWidget {
  const PilotHomeShell({super.key});

  @override
  ConsumerState<PilotHomeShell> createState() => _PilotHomeShellState();
}

class _PilotHomeShellState extends ConsumerState<PilotHomeShell> {
  var _index = 0;
  var _toggling = false;
  LocationUpdateStrategy? _location;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bootstrapPush(ref);
      final loc = await Permission.locationWhenInUse.status;
      final notif = await Permission.notification.status;
      await ref.read(devicesRepositoryProvider).syncPermissions(
            locationPermission: loc.isGranted
                ? 'whileInUse'
                : loc.isPermanentlyDenied
                    ? 'denied'
                    : 'unknown',
            notificationPermission: notif.isGranted ? 'granted' : notif.isDenied ? 'denied' : 'unknown',
          );
    });
  }

  @override
  void dispose() {
    unawaited(_location?.stop());
    super.dispose();
  }

  Future<(double, double)> _coords() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return (pos.latitude, pos.longitude);
    } catch (_) {
      return (17.9689, 79.5941);
    }
  }

  Future<void> _setOnline(bool online) async {
    setState(() => _toggling = true);
    try {
      final (lat, lng) = await _coords();
      await ref.read(pilotRideRepositoryProvider).setOnline(online: online, lat: lat, lng: lng);
      ref.read(pilotOnlineProvider.notifier).state = online;
      if (online) {
        ref.read(pilotOfferProvider.notifier).startPolling();
        _location ??= LocationUpdateStrategy(ref.read(pilotRideRepositoryProvider));
        await _location!.start();
      } else {
        ref.read(pilotOfferProvider.notifier).stopPolling();
        await _location?.stop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is AppFailure ? e.message : e.toString())),
      );
    } finally {
      if (mounted) setState(() => _toggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final online = ref.watch(pilotOnlineProvider);
    final pages = [
      _RequestTab(
        online: online,
        toggling: _toggling,
        onToggle: _setOnline,
      ),
      const EarningsTab(),
      const ReviewsTab(),
    ];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: PrilaBottomNav(
        index: _index,
        onChanged: (i) {
          if (i == 3) {
            context.push('/wallet');
            return;
          }
          setState(() => _index = i);
        },
        labels: [l10n.requestTab, l10n.earningTab, l10n.reviewTab, l10n.walletTab],
      ),
    );
  }
}

class _RequestTab extends ConsumerWidget {
  const _RequestTab({
    required this.online,
    required this.toggling,
    required this.onToggle,
  });
  final bool online;
  final bool toggling;
  final ValueChanged<bool> onToggle;

  String _inr(int? paise) => '₹${((paise ?? 0) / 100).toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.prilaColors;
    final offerAsync = ref.watch(pilotOfferProvider);
    final ride = offerAsync.valueOrNull;
    final status = ride?['status'] as String?;
    final isOffer = status == 'searching';
    final isActive = status != null &&
        const {'pilot_assigned', 'pilot_arriving', 'pilot_arrived', 'in_progress'}.contains(status);
    final today = ref.watch(homeTodayEarningsProvider);
    final netLabel = today.maybeWhen(
      data: (d) => _inr((d['netPaise'] as num?)?.toInt()),
      orElse: () => '—',
    );
    final tripsLabel = today.maybeWhen(
      data: (d) => '${(d['trips'] as num?)?.toInt() ?? 0}',
      orElse: () => '—',
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Text(
                l10n.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(onPressed: () => context.push('/account'), icon: const Icon(Icons.person_outline)),
            ],
          ),
          Text(l10n.helloPilot),
          const SizedBox(height: 16),
          PrilaCard(
            child: Row(
              children: [
                Expanded(child: Text(online ? l10n.youAreOnline : l10n.youAreOffline)),
                if (toggling)
                  const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Switch(value: online, onChanged: onToggle, activeThumbColor: colors.pickup),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (online && isOffer && ride != null)
            PrilaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text((ride['serviceType'] as String? ?? 'ride').toUpperCase()),
                    backgroundColor: colors.secondary.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 8),
                  LocationPairTile(
                    pickupLabel: l10n.pickup,
                    dropLabel: l10n.drop,
                    pickup: (ride['pickup'] as Map?)?['name']?.toString() ?? l10n.pickup,
                    drop: (ride['drop'] as Map?)?['name']?.toString() ?? l10n.drop,
                  ),
                  const SizedBox(height: 12),
                  FareChip(amountPaise: (ride['fareTotalPaise'] as num?)?.toInt() ?? 0),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final id = ride['id'] as String?;
                            if (id == null) return;
                            await ref.read(pilotRideRepositoryProvider).skip(id);
                            await ref.read(pilotOfferProvider.notifier).refresh();
                          },
                          child: Text(l10n.skip),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PrilaGradientButton(
                          label: l10n.accept,
                          onPressed: () async {
                            final id = ride['id'] as String?;
                            if (id == null) return;
                            try {
                              final accepted = await ref.read(pilotRideRepositoryProvider).accept(
                                    id,
                                    'accept-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 32)}',
                                  );
                              await ref.read(pilotOfferProvider.notifier).refresh();
                              final aid = accepted['id'] as String?;
                              if (aid != null && context.mounted) context.push('/ride/$aid');
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e is AppFailure ? e.message : e.toString())),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else if (online && isActive && ride != null)
            PrilaCard(
              onTap: () {
                final id = ride['id'] as String?;
                if (id != null) context.push('/ride/$id');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.activeRide, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(status),
                  TextButton(
                    onPressed: () {
                      final id = ride['id'] as String?;
                      if (id != null) context.push('/ride/$id');
                    },
                    child: Text(l10n.continueTrip),
                  ),
                ],
              ),
            )
          else if (online)
            PrilaCard(
              child: Text(
                l10n.waitingOffers,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: l10n.todaysEarnings,
                  value: netLabel,
                  onTap: () => ref.invalidate(homeTodayEarningsProvider),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  label: l10n.completedTrips,
                  value: tripsLabel,
                  onTap: () => ref.invalidate(homeTodayEarningsProvider),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PilotAccountPage extends ConsumerWidget {
  const PilotAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pilotAccount)),
      body: ListView(
        children: [
          SettingsTile(
            label: l10n.darkMode,
            leading: const Icon(Icons.dark_mode_outlined),
            trailing: Switch(
              value: mode == ThemeMode.dark,
              onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
            ),
          ),
          SettingsTile(label: l10n.language, leading: const Icon(Icons.language)),
          SettingsTile(
            label: l10n.logOut,
            danger: true,
            leading: Icon(Icons.logout, color: context.prilaColors.danger),
            onTap: () async {
              ref.read(pilotOfferProvider.notifier).stopPolling();
              await ref.read(authRepositoryProvider).logout();
              ref.invalidate(authSessionProvider);
              if (context.mounted) context.go('/login');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: context.prilaColors.danger),
              child: Text(l10n.deleteAccount),
            ),
          ),
        ],
      ),
    );
  }
}
