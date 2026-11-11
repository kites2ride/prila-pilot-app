import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pilot/core/config/bootstrap_provider.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/l10n/app_localizations.dart';

class UpdatePage extends ConsumerWidget {
  const UpdatePage({super.key, required this.requiredUpdate});

  final bool requiredUpdate;

  Future<void> _update(WidgetRef ref) async {
    final cfg = ref.read(bootstrapProvider).valueOrNull;
    if (Platform.isAndroid) {
      try {
        final info = await InAppUpdate.checkForUpdate();
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          await InAppUpdate.performImmediateUpdate();
          return;
        }
      } catch (_) {}
    }
    final url = cfg?.storeUrl;
    if (url != null && url.isNotEmpty) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                requiredUpdate ? l10n.updateRequiredTitle : l10n.updateOptionalTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrilaGradientButton(label: l10n.updateNow, onPressed: () => _update(ref)),
              if (!requiredUpdate) ...[
                const SizedBox(height: 12),
                TextButton(onPressed: () => context.go('/home'), child: Text(l10n.later)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
