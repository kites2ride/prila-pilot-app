import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/widgets/empty_error_states.dart';
import 'package:pilot/core/widgets/prila_card.dart';
import 'package:pilot/features/money/data/money_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

final earningsRangeProvider = StateProvider<String>((ref) => 'today');

final earningsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  final range = ref.watch(earningsRangeProvider);
  return ref.watch(moneyRepositoryProvider).earnings(range);
});

class EarningsTab extends ConsumerWidget {
  const EarningsTab({super.key});

  String _inr(int? paise) => '₹${((paise ?? 0) / 100).toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final range = ref.watch(earningsRangeProvider);
    final async = ref.watch(earningsProvider);
    final colors = context.prilaColors;

    return SafeArea(
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString(), onRetry: () => ref.invalidate(earningsProvider)),
        data: (data) {
          final chart = (data['chart'] as List?) ?? [];
          final tx = (data['transactions'] as List?) ?? [];
          final maxBar = chart.fold<int>(1, (m, e) {
            final v = ((e as Map)['amountPaise'] as num?)?.toInt() ?? 0;
            return v > m ? v : m;
          });

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(earningsProvider),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(l10n.earningTab, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'today', label: Text(l10n.rangeToday)),
                    ButtonSegment(value: 'week', label: Text(l10n.rangeWeek)),
                    ButtonSegment(value: 'month', label: Text(l10n.rangeMonth)),
                  ],
                  selected: {range},
                  onSelectionChanged: (s) => ref.read(earningsRangeProvider.notifier).state = s.first,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: PrilaCard(
                        child: Column(
                          children: [
                            Text(l10n.netEarnings),
                            const SizedBox(height: 8),
                            Text(
                              _inr((data['netPaise'] as num?)?.toInt()),
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrilaCard(
                        child: Column(
                          children: [
                            Text(l10n.platformFee),
                            const SizedBox(height: 8),
                            Text(
                              _inr((data['commissionPaise'] as num?)?.toInt()),
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colors.danger),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${l10n.completedTrips}: ${(data['trips'] as num?)?.toInt() ?? 0}'),
                if (chart.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l10n.earningsChart, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final e in chart)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                height: 8 +
                                    100 *
                                        (((e as Map)['amountPaise'] as num?)?.toInt() ?? 0) /
                                        maxBar,
                                decoration: BoxDecoration(
                                  gradient: colors.brandGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text(l10n.transactions, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (tx.isEmpty) Text(l10n.emptyGeneric),
                for (final raw in tx)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PrilaCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((raw as Map)['type']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                                if (raw['note'] != null) Text(raw['note'].toString(), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Text(_inr((raw['amountPaise'] as num?)?.toInt())),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
