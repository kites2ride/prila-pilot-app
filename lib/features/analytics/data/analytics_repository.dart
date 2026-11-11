import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/network/api_client.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) => AnalyticsRepository(ref.watch(dioProvider)),
);

/// Fire-and-forget analytics writer. Backend route may 404 until Phase 6 — failures are ignored.
class AnalyticsRepository {
  AnalyticsRepository(this._dio);
  final Dio _dio;

  Future<void> track({
    required String name,
    Map<String, dynamic>? props,
    int? durationSec,
  }) async {
    try {
      await _dio.post<void>(
        '/analytics/events',
        data: {
          'name': name,
          'app': 'pilot',
          'props': props ?? {},
          if (durationSec != null) 'durationSec': durationSec,
        },
      );
    } catch (_) {
      // never block UX
    }
  }
}
