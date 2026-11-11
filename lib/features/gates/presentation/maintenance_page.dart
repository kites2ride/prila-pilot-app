import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/config/bootstrap_provider.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/l10n/app_localizations.dart';

class MaintenancePage extends ConsumerWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cfg = ref.watch(bootstrapProvider).valueOrNull;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.maintenanceTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(cfg?.maintenanceMessage ?? 'Please try again shortly.', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              PrilaGradientButton(
                label: l10n.retry,
                onPressed: () => ref.read(bootstrapProvider.notifier).refresh(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
