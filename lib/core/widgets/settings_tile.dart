import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_theme.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.label,
    this.leading,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  final String label;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(
        label,
        style: TextStyle(
          color: danger ? colors.danger : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      minVerticalPadding: 16,
    );
  }
}
