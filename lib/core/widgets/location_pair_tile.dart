import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class LocationPairTile extends StatelessWidget {
  const LocationPairTile({
    super.key,
    required this.pickup,
    required this.drop,
    this.pickupLabel = 'Pickup',
    this.dropLabel = 'Drop',
  });

  final String pickup;
  final String drop;
  final String pickupLabel;
  final String dropLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _Dot(color: colors.pickup),
            Container(
              width: 2,
              height: 28,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: colors.border,
              ),
            ),
            _Dot(color: colors.drop),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickupLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.pickup,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(pickup, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 14),
              Text(
                dropLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.drop,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(drop, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
