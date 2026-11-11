import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/widgets/prila_card.dart';

class PilotInfoCard extends StatelessWidget {
  const PilotInfoCard({
    super.key,
    required this.name,
    this.vehicleNumber,
    this.vehicleType,
    this.rating,
    this.onCall,
  });

  final String name;
  final String? vehicleNumber;
  final String? vehicleType;
  final double? rating;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return PrilaCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.primary.withValues(alpha: 0.12),
            child: Icon(Icons.person_rounded, color: colors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                if (vehicleNumber != null || vehicleType != null)
                  Text(
                    [vehicleType, vehicleNumber].whereType<String>().join(' · '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (rating != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: colors.brandGradient.colors.first),
                      const SizedBox(width: 4),
                      Text(rating!.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onCall != null)
            IconButton.filled(
              onPressed: onCall,
              style: IconButton.styleFrom(backgroundColor: colors.pickup),
              icon: const Icon(Icons.phone_rounded, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
