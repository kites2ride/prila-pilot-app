import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/errors/app_failure.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/widgets/empty_error_states.dart';
import 'package:pilot/core/widgets/prila_card.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/features/money/data/money_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

final walletProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  return ref.watch(moneyRepositoryProvider).wallet();
});

final payoutsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  return ref.watch(moneyRepositoryProvider).payouts();
});

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final _upi = TextEditingController();
  final _amount = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _upi.dispose();
    _amount.dispose();
    super.dispose();
  }

  String _inr(int? paise) => '₹${((paise ?? 0) / 100).toStringAsFixed(0)}';

  Future<void> _request() async {
    final rupees = int.tryParse(_amount.text.trim());
    if (rupees == null || rupees <= 0) return;
    setState(() => _busy = true);
    try {
      await ref.read(moneyRepositoryProvider).requestPayout(
            amountPaise: rupees * 100,
            upiId: _upi.text.trim().isEmpty ? null : _upi.text.trim(),
          );
      ref.invalidate(walletProvider);
      ref.invalidate(payoutsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).payoutRequested)));
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.prilaColors;
    final wallet = ref.watch(walletProvider);
    final payouts = ref.watch(payoutsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletTab)),
      body: wallet.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString(), onRetry: () => ref.invalidate(walletProvider)),
        data: (w) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              PrilaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.withdrawableBalance),
                    Text(
                      _inr((w['balancePaise'] as num?)?.toInt()),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${l10n.platformDues}: ${_inr((w['duesPaise'] as num?)?.toInt())}',
                      style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${l10n.lifetimeNet}: ${_inr((w['lifetimeNetPaise'] as num?)?.toInt())}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.requestPayout, style: Theme.of(context).textTheme.titleMedium),
              TextField(controller: _amount, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.amountInr)),
              TextField(controller: _upi, decoration: InputDecoration(labelText: l10n.upiId)),
              const SizedBox(height: 12),
              PrilaGradientButton(label: l10n.requestPayout, loading: _busy, onPressed: _busy ? null : _request),
              const SizedBox(height: 24),
              Text(l10n.payoutHistory, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              payouts.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text(e.toString()),
                data: (p) {
                  final items = (p['items'] as List?) ?? [];
                  if (items.isEmpty) return Text(l10n.emptyGeneric);
                  return Column(
                    children: [
                      for (final raw in items)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_inr(((raw as Map)['amountPaise'] as num?)?.toInt())),
                          subtitle: Text(raw['status']?.toString() ?? ''),
                          trailing: Text(raw['method']?.toString() ?? ''),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
