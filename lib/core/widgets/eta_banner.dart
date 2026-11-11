import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class EtaBanner extends StatelessWidget {
  const EtaBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colors.primary.withValues(alpha: 0.1),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, color: colors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w600, color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
