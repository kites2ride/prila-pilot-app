import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/network/api_client.dart';
import 'package:pilot/core/storage/secure_store.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider), ref.watch(secureStoreProvider)),
);

class AuthRepository {
  AuthRepository(this._dio, this._store);

  final Dio _dio;
  final SecureStore _store;

  Future<String?> requestOtp(String phone) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/otp/request',
        data: {'phone': phone, 'app': 'pilot'},
      );
      return res.data?['debugCode'] as String?;
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {'phone': phone, 'app': 'pilot', 'code': code},
      );
      final data = res.data ?? {};
      await _store.write(SecureStore.accessTokenKey, data['accessToken'] as String);
      await _store.write(SecureStore.refreshTokenKey, data['refreshToken'] as String);
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<bool> hasSession() async {
    final token = await _store.read(SecureStore.accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() => _store.clearSession();
}

final authSessionProvider = FutureProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).hasSession();
});
