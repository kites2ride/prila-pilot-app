import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class PrilaAppHeader extends StatelessWidget {
  const PrilaAppHeader({
    super.key,
    required this.greeting,
    this.onBell,
    this.onProfile,
    this.trailing,
  });

  final String greeting;
  final VoidCallback? onBell;
  final VoidCallback? onProfile;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => colors.brandGradient.createShader(bounds),
              child: Text(
                'prila',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
              ),
            ),
            const Spacer(),
            if (onBell != null)
              IconButton(
                onPressed: onBell,
                icon: Icon(Icons.notifications_none_rounded, color: colors.primary),
              ),
            if (onProfile != null)
              IconButton(
                onPressed: onProfile,
                icon: const Icon(Icons.person_outline_rounded),
              ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 4),
        Text(
          greeting,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: colors.brandGradient,
          ),
        ),
      ],
    );
  }
}
