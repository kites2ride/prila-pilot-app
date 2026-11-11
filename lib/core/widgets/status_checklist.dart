import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class StatusChecklist extends StatelessWidget {
  const StatusChecklist({super.key, required this.steps, required this.activeIndex});

  final List<String> steps;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < activeIndex
                        ? colors.pickup
                        : i == activeIndex
                            ? colors.primary
                            : colors.border,
                  ),
                  child: i < activeIndex
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w500,
                      color: i <= activeIndex
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
