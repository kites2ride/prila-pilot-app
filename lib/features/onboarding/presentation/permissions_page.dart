import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pilot/core/storage/secure_store.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/l10n/app_localizations.dart';

class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key});

  Future<void> _allow(WidgetRef ref, BuildContext context) async {
    await Permission.locationWhenInUse.request();
    await Permission.notification.request();
    await ref.read(secureStoreProvider).write(SecureStore.permissionsDoneKey, '1');
    if (context.mounted) context.go('/login');
  }

  Future<void> _skip(WidgetRef ref, BuildContext context) async {
    await ref.read(secureStoreProvider).write(SecureStore.permissionsDoneKey, '1');
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.permissionsTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(l10n.permissionsBody),
              const Spacer(),
              PrilaGradientButton(label: l10n.allowPermissions, onPressed: () => _allow(ref, context)),
              const SizedBox(height: 12),
              TextButton(onPressed: () => _skip(ref, context), child: Text(l10n.skipForNow)),
            ],
          ),
        ),
      ),
    );
  }
}
