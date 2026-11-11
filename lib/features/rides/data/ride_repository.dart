import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/network/api_client.dart';

final pilotRideRepositoryProvider = Provider<PilotRideRepository>(
  (ref) => PilotRideRepository(ref.watch(dioProvider)),
);

class PilotRideRepository {
  PilotRideRepository(this._dio);
  final Dio _dio;

  Future<void> setOnline({required bool online, required double lat, required double lng}) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/pilot/online',
        data: {'online': online, 'lat': lat, 'lng': lng},
      );
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> updateLocation({required double lat, required double lng}) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/pilot/location',
        data: {'lat': lat, 'lng': lng},
      );
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> offers() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/pilot/rides/offers');
      final items = res.data?['items'] as List? ?? [];
      return items.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>?> active() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/pilot/rides/active');
      return res.data?['ride'] as Map<String, dynamic>?;
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> get(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/pilot/rides/$id');
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> accept(String id, String idempotencyKey) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/pilot/rides/$id/accept',
        data: {'idempotencyKey': idempotencyKey},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> skip(String id) async {
    try {
      await _dio.post<Map<String, dynamic>>('/pilot/rides/$id/skip', data: {});
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> arrived(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('/pilot/rides/$id/arrived', data: {});
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> start(String id, String otp) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/pilot/rides/$id/start',
        data: {'otp': otp},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> complete(String id, {required bool collectedCash}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/pilot/rides/$id/complete',
        data: {'collectedCash': collectedCash},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> cancel(String id, String reasonCode) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/pilot/rides/$id/cancel',
        data: {'reasonCode': reasonCode},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }
}
