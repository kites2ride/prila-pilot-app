import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/config/app_env.dart';
import 'package:pilot/core/errors/app_failure.dart';
import 'package:pilot/core/storage/secure_store.dart';

final dioProvider = Provider<Dio>((ref) {
  final store = ref.watch(secureStoreProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  var refreshing = false;
  Completer<void>? refreshCompleter;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await store.read(SecureStore.accessTokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        final data = response.data;
        if (data is Map && data['ok'] == false) {
          final err = data['error'] as Map? ?? {};
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              error: ServerFailure(
                (err['message'] as String?) ?? 'Request failed',
                code: err['code'] as String?,
              ),
            ),
          );
          return;
        }
        if (data is Map && data.containsKey('data')) {
          response.data = data['data'];
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && !error.requestOptions.path.contains('/auth/')) {
          if (!refreshing) {
            refreshing = true;
            refreshCompleter = Completer<void>();
            try {
              final refresh = await store.read(SecureStore.refreshTokenKey);
              if (refresh == null) throw const UnauthorizedFailure();
              final refreshDio = Dio(BaseOptions(baseUrl: AppEnv.apiBaseUrl));
              final res = await refreshDio.post<Map<String, dynamic>>(
                '/auth/refresh',
                data: {'refreshToken': refresh},
              );
              final body = res.data;
              final payload = body?['data'] as Map<String, dynamic>? ?? body;
              final access = payload?['accessToken'] as String?;
              final nextRefresh = payload?['refreshToken'] as String?;
              if (access == null) throw const UnauthorizedFailure();
              await store.write(SecureStore.accessTokenKey, access);
              if (nextRefresh != null) {
                await store.write(SecureStore.refreshTokenKey, nextRefresh);
              }
              refreshCompleter?.complete();
            } catch (_) {
              await store.clearSession();
              refreshCompleter?.completeError(const UnauthorizedFailure());
              handler.reject(error);
              refreshing = false;
              refreshCompleter = null;
              return;
            } finally {
              refreshing = false;
            }
          } else {
            try {
              await refreshCompleter?.future;
            } catch (_) {
              handler.reject(error);
              return;
            }
          }

          final token = await store.read(SecureStore.accessTokenKey);
          final req = error.requestOptions;
          req.headers['Authorization'] = 'Bearer $token';
          try {
            final clone = await dio.fetch<dynamic>(req);
            handler.resolve(clone);
            return;
          } catch (e) {
            handler.reject(error);
            return;
          }
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});

AppFailure mapDioError(Object error) {
  if (error is AppFailure) return error;
  if (error is DioException) {
    final nested = error.error;
    if (nested is AppFailure) return nested;
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    final data = error.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = data['error'] as Map;
      return ServerFailure(
        (err['message'] as String?) ?? 'Request failed',
        code: err['code'] as String?,
      );
    }
    return ServerFailure(error.message ?? 'Request failed');
  }
  return UnknownFailure(error.toString());
}
