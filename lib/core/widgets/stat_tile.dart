import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/widgets/prila_card.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.accent,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return PrilaCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent ?? colors.primary,
                ),
          ),
        ],
      ),
    );
  }
}
