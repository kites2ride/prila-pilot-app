import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilot/core/config/app_env.dart';
import 'package:pilot/core/config/bootstrap_models.dart';
import 'package:pilot/core/network/api_client.dart';
import 'package:pilot/core/storage/secure_store.dart';

final bootstrapProvider =
    StateNotifierProvider<BootstrapController, AsyncValue<BootstrapConfig>>(
  (ref) => BootstrapController(ref),
);

class BootstrapController extends StateNotifier<AsyncValue<BootstrapConfig>> {
  BootstrapController(this._ref) : super(const AsyncValue.loading()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    final store = _ref.read(secureStoreProvider);
    final dio = _ref.read(dioProvider);
    try {
      final info = await PackageInfo.fromPlatform();
      final build = int.tryParse(info.buildNumber) ?? 0;
      final platform = Platform.isIOS ? 'ios' : 'android';
      final res = await dio.get<Map<String, dynamic>>(
        '/app/bootstrap',
        queryParameters: {
          'app': AppEnv.appKind,
          'platform': platform,
          'build': build,
        },
      );
      final cfg = BootstrapConfig.fromJson(res.data ?? {});
      await store.write(SecureStore.bootstrapCacheKey, jsonEncode(cfg.toJson()));
      state = AsyncValue.data(cfg);
    } catch (e, st) {
      final cached = await store.read(SecureStore.bootstrapCacheKey);
      if (cached != null) {
        try {
          state = AsyncValue.data(
            BootstrapConfig.fromJson(jsonDecode(cached) as Map<String, dynamic>),
          );
          return;
        } catch (_) {}
      }
      // Fail open to safe defaults
      state = AsyncValue.data(BootstrapConfig.safeDefaults());
      // keep stack for debug only
      assert(() {
        // ignore: avoid_print
        print('bootstrap failed: $e\n$st');
        return true;
      }());
    }
  }
}

final packageInfoProvider = FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());
