import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class PrilaBottomNav extends StatelessWidget {
  const PrilaBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
    required this.labels,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    final icons = const [
      Icons.home_rounded,
      Icons.payments_rounded,
      Icons.star_rounded,
      Icons.account_balance_wallet_rounded,
    ];
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: onChanged,
      backgroundColor: colors.surface,
      elevation: 0,
      height: 72,
      indicatorColor: colors.primary.withValues(alpha: 0.14),
      destinations: [
        for (var i = 0; i < labels.length; i++)
          NavigationDestination(
            icon: Icon(icons[i]),
            selectedIcon: ShaderMask(
              shaderCallback: (b) => colors.brandGradient.createShader(b),
              child: Icon(icons[i], color: Colors.white),
            ),
            label: labels[i],
          ),
      ],
    );
  }
}
