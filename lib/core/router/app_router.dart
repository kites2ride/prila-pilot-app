import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilot/core/config/bootstrap_provider.dart';
import 'package:pilot/core/storage/secure_store.dart';
import 'package:pilot/features/auth/data/auth_repository.dart';
import 'package:pilot/features/auth/presentation/otp_page.dart';
import 'package:pilot/features/auth/presentation/phone_login_page.dart';
import 'package:pilot/features/gates/presentation/maintenance_page.dart';
import 'package:pilot/features/gates/presentation/update_page.dart';
import 'package:pilot/features/home/presentation/pilot_home_shell.dart';
import 'package:pilot/features/kyc/data/kyc_repository.dart';
import 'package:pilot/features/kyc/presentation/kyc_page.dart';
import 'package:pilot/features/kyc/presentation/kyc_review_page.dart';
import 'package:pilot/features/onboarding/presentation/permissions_page.dart';
import 'package:pilot/features/money/presentation/wallet_page.dart';
import 'package:pilot/features/rides/presentation/active_ride_page.dart';
import 'package:pilot/features/splash/presentation/splash_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authSessionProvider, (_, __) => refresh.value++);
  ref.listen(bootstrapProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/permissions', builder: (_, __) => const PermissionsPage()),
      GoRoute(path: '/login', builder: (_, __) => const PhoneLoginPage()),
      GoRoute(
        path: '/otp',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OtpPage(
            phone: extra['phone'] as String? ?? '',
            debugCode: extra['debugCode'] as String?,
          );
        },
      ),
      GoRoute(path: '/kyc', builder: (_, __) => const KycPage()),
      GoRoute(path: '/kyc-review', builder: (_, __) => const KycReviewPage()),
      GoRoute(path: '/home', builder: (_, __) => const PilotHomeShell()),
      GoRoute(
        path: '/ride/:id',
        builder: (_, state) => ActiveRidePage(rideId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/wallet', builder: (_, __) => const WalletPage()),
      GoRoute(path: '/account', builder: (_, __) => const PilotAccountPage()),
      GoRoute(path: '/maintenance', builder: (_, __) => const MaintenancePage()),
      GoRoute(
        path: '/update',
        builder: (_, state) => UpdatePage(requiredUpdate: state.uri.queryParameters['required'] == '1'),
      ),
    ],
    redirect: (context, state) async {
      final loc = state.matchedLocation;
      if (loc == '/splash') return null;

      final cfg = ref.read(bootstrapProvider).valueOrNull;
      if (cfg != null && cfg.maintenanceEnabled && loc != '/maintenance') return '/maintenance';

      if (cfg != null && cfg.updateMode == 'required' && loc != '/update') {
        final info = await PackageInfo.fromPlatform();
        final build = int.tryParse(info.buildNumber) ?? 0;
        if (cfg.minBuild > 0 && build < cfg.minBuild) return '/update?required=1';
      }

      final store = ref.read(secureStoreProvider);
      final perms = await store.read(SecureStore.permissionsDoneKey);
      final authed = await ref.read(authRepositoryProvider).hasSession();
      final kyc = await store.read(KycRepository.statusKey) ?? 'not_started';

      if (perms != '1' && loc != '/permissions') return '/permissions';
      if (perms == '1' && !authed && loc != '/login' && loc != '/otp') return '/login';
      if (authed && (loc == '/login' || loc == '/otp' || loc == '/permissions')) {
        if (kyc == 'approved') return '/home';
        if (kyc == 'pending' || kyc == 'rejected') return '/kyc-review';
        return '/kyc';
      }
      if (authed && loc == '/home' && kyc != 'approved') {
        return kyc == 'pending' || kyc == 'rejected' ? '/kyc-review' : '/kyc';
      }
      return null;
    },
  );
});
