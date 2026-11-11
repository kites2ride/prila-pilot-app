import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/network/api_client.dart';

final moneyRepositoryProvider = Provider<MoneyRepository>(
  (ref) => MoneyRepository(ref.watch(dioProvider)),
);

class MoneyRepository {
  MoneyRepository(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> wallet() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/pilot/wallet');
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> earnings(String range) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/pilot/earnings',
        queryParameters: {'range': range},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> reviews() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/pilot/reviews',
        queryParameters: {'page': 1, 'limit': 30},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> payouts() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/pilot/payouts',
        queryParameters: {'page': 1, 'limit': 20},
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> requestPayout({
    required int amountPaise,
    String? upiId,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/pilot/payouts',
        data: {
          'amountPaise': amountPaise,
          'method': 'upi',
          'upiId': ?upiId,
        },
      );
      return res.data ?? {};
    } catch (e) {
      throw mapDioError(e);
    }
  }
}
