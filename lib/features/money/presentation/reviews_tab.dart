import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/widgets/empty_error_states.dart';
import 'package:pilot/core/widgets/prila_card.dart';
import 'package:pilot/features/money/data/money_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

final reviewsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  return ref.watch(moneyRepositoryProvider).reviews();
});

class ReviewsTab extends ConsumerWidget {
  const ReviewsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.prilaColors;
    final async = ref.watch(reviewsProvider);

    return SafeArea(
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString(), onRetry: () => ref.invalidate(reviewsProvider)),
        data: (data) {
          final items = (data['items'] as List?) ?? [];
          final avg = (data['average'] as num?)?.toDouble();
          final count = (data['count'] as num?)?.toInt() ?? 0;

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(reviewsProvider),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(l10n.reviewTab, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                PrilaCard(
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: colors.primary, size: 40),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            avg != null ? avg.toStringAsFixed(1) : '—',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          Text('${l10n.fromReviews}: $count'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty) EmptyState(message: l10n.noReviewsYet),
                for (final raw in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PrilaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                final r = ((raw as Map)['rating'] as num?)?.toInt() ?? 0;
                                return Icon(
                                  i < r ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: i < r ? colors.primary : colors.border,
                                  size: 18,
                                );
                              }),
                              const Spacer(),
                              Text((raw as Map)['serviceType']?.toString() ?? ''),
                            ],
                          ),
                          if (((raw)['tags'] as List?)?.isNotEmpty == true)
                            Text(((raw)['tags'] as List).join(' · '), style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            '${raw['pickup'] ?? ''} → ${raw['drop'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
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
