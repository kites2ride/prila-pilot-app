import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pilot/core/config/bootstrap_provider.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/features/analytics/data/analytics_repository.dart';
import 'package:pilot/features/auth/data/auth_repository.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await ref.read(bootstrapProvider.notifier).refresh();
    ref.read(analyticsRepositoryProvider).track(name: 'app_open');
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final authed = await ref.read(authRepositoryProvider).hasSession();
    if (!mounted) return;
    context.go(authed ? '/home' : '/permissions');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.prilaColors;
    return Scaffold(
      body: Center(
        child: Text(
          'prila',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..shader = colors.brandGradient.createShader(const Rect.fromLTWH(0, 0, 200, 60)),
              ),
        ),
      ),
    );
  }
}
