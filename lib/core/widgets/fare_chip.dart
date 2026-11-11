import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class FareChip extends StatelessWidget {
  const FareChip({super.key, required this.amountPaise, this.label});

  final int amountPaise;
  final String? label;

  String get _inr => '₹${(amountPaise / 100).toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: colors.brandGradient,
      ),
      child: Text(
        label == null ? _inr : '$label $_inr',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}
