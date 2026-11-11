import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/router/app_router.dart';
import 'package:pilot/core/theme/prila_theme.dart';
import 'package:pilot/core/theme/theme_mode_controller.dart';
import 'package:pilot/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PrilaPilotApp()));
}

class PrilaPilotApp extends ConsumerWidget {
  const PrilaPilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Prila Pilot',
      theme: PrilaTheme.light(),
      darkTheme: PrilaTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
    );
  }
}
