import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pilot/core/errors/app_failure.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/widgets/prila_card.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/features/rides/application/pilot_ride_session.dart';
import 'package:pilot/features/rides/data/ride_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

class ActiveRidePage extends ConsumerStatefulWidget {
  const ActiveRidePage({super.key, required this.rideId});
  final String rideId;

  @override
  ConsumerState<ActiveRidePage> createState() => _ActiveRidePageState();
}

class _ActiveRidePageState extends ConsumerState<ActiveRidePage> {
  final _otpCtrl = TextEditingController();
  var _busy = false;
  Map<String, dynamic>? _ride;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final ride = await ref.read(pilotRideRepositoryProvider).get(widget.rideId);
      if (mounted) setState(() => _ride = ride);
    } catch (_) {}
  }

  Future<void> _run(Future<Map<String, dynamic>> Function() action) async {
    setState(() => _busy = true);
    try {
      final ride = await action();
      setState(() => _ride = ride);
      await ref.read(pilotOfferProvider.notifier).refresh();
      final status = ride['status'] as String?;
      if ((status == 'completed' || status == 'paid') && mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is AppFailure ? e.message : e.toString())),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _inr(int? paise) => '₹${((paise ?? 0) / 100).toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.prilaColors;
    final status = _ride?['status'] as String?;
    final farePaise = (_ride?['fareTotalPaise'] as num?)?.toInt();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.activeRide)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PrilaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status ?? '…', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(l10n.pickup, style: TextStyle(color: colors.pickup, fontWeight: FontWeight.w600)),
                Text((_ride?['pickup'] as Map?)?['name']?.toString() ?? '—'),
                const SizedBox(height: 8),
                Text(l10n.drop, style: TextStyle(color: colors.drop, fontWeight: FontWeight.w600)),
                Text((_ride?['drop'] as Map?)?['name']?.toString() ?? '—'),
                const SizedBox(height: 8),
                Text('${l10n.fare}: ${_inr(farePaise)}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (status == 'pilot_assigned' || status == 'pilot_arriving')
            PrilaGradientButton(
              label: l10n.iveArrived,
              loading: _busy,
              onPressed: _busy
                  ? null
                  : () => _run(() => ref.read(pilotRideRepositoryProvider).arrived(widget.rideId)),
            ),
          if (status == 'pilot_arrived') ...[
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(labelText: l10n.enterRideOtp),
            ),
            const SizedBox(height: 8),
            PrilaGradientButton(
              label: l10n.startTrip,
              loading: _busy,
              onPressed: _busy
                  ? null
                  : () => _run(
                        () => ref.read(pilotRideRepositoryProvider).start(
                              widget.rideId,
                              _otpCtrl.text.trim(),
                            ),
                      ),
            ),
          ],
          if (status == 'in_progress')
            PrilaGradientButton(
              label: l10n.completeTrip,
              loading: _busy,
              onPressed: _busy
                  ? null
                  : () => _run(
                        () => ref.read(pilotRideRepositoryProvider).complete(
                              widget.rideId,
                              collectedCash: true,
                            ),
                      ),
            ),
        ],
      ),
    );
  }
}
