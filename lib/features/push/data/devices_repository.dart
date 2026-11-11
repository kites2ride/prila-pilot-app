import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/network/api_client.dart';

final devicesRepositoryProvider = Provider<DevicesRepository>(
  (ref) => DevicesRepository(ref.watch(dioProvider)),
);

class DevicesRepository {
  DevicesRepository(this._dio);
  final Dio _dio;

  Future<void> registerPushToken({required String pushToken, required String platform}) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/devices/push-token',
        data: {'pushToken': pushToken, 'platform': platform},
      );
    } catch (_) {
      /* optional until FCM ready */
    }
  }

  Future<void> syncPermissions({
    String? locationPermission,
    String? notificationPermission,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/devices/permissions',
        data: {
          'locationPermission': ?locationPermission,
          'notificationPermission': ?notificationPermission,
        },
      );
    } catch (_) {
      /* ignore */
    }
  }

  Future<List<Map<String, dynamic>>> notifications() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/notifications',
        queryParameters: {'page': 1, 'limit': 40},
      );
      final items = res.data?['items'];
      if (items is List) {
        return items.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> markRead(String id) async {
    try {
      await _dio.post<Map<String, dynamic>>('/notifications/$id/read');
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> createShare(String rideId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('/rides/$rideId/share');
      return res.data;
    } catch (_) {
      return null;
    }
  }

  Future<void> triggerSos({String? rideId, double? lat, double? lng}) async {
    await _dio.post<Map<String, dynamic>>(
      '/sos',
      data: {
        'rideId': ?rideId,
        'lat': ?lat,
        'lng': ?lng,
      },
    );
  }
}
