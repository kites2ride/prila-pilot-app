import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pilot/core/storage/secure_store.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/features/kyc/data/kyc_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

class KycReviewPage extends ConsumerWidget {
  const KycReviewPage({super.key});

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
              Text(l10n.underReviewTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(l10n.underReviewBody),
              const Spacer(),
              PrilaGradientButton(
                label: l10n.resubmit,
                onPressed: () => context.go('/kyc'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await ref.read(secureStoreProvider).write(KycRepository.statusKey, 'approved');
                  if (context.mounted) context.go('/home');
                },
                child: const Text('Dev: mark approved'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
