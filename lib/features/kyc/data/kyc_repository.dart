import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/core/network/api_client.dart';
import 'package:pilot/core/storage/secure_store.dart';

final kycRepositoryProvider = Provider<KycRepository>(
  (ref) => KycRepository(ref.watch(dioProvider), ref.watch(secureStoreProvider)),
);

class KycRepository {
  KycRepository(this._dio, this._store);
  final Dio _dio;
  final SecureStore _store;

  static const statusKey = 'kyc_status';
  static const rejectReasonKey = 'kyc_reject_reason';

  Future<String> status() async => (await _store.read(statusKey)) ?? 'not_started';

  Future<String?> rejectReason() => _store.read(rejectReasonKey);

  /// Presign via backend R2, then PUT file bytes to upload URL.
  Future<String> uploadDocument({
    required File file,
    required String folder,
    required String contentType,
  }) async {
    try {
      final presign = await _dio.post<Map<String, dynamic>>(
        '/uploads/presign',
        data: {
          'folder': folder,
          'contentType': contentType,
          'extension': file.path.split('.').last,
        },
      );
      final data = presign.data ?? {};
      final uploadUrl = data['uploadUrl'] as String?;
      final publicUrl = data['publicUrl'] as String?;
      if (uploadUrl == null || publicUrl == null) {
        throw StateError('Presign failed');
      }
      final bytes = await file.readAsBytes();
      await Dio().put<void>(
        uploadUrl,
        data: bytes,
        options: Options(
          headers: {
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: bytes.length,
          },
        ),
      );
      return publicUrl;
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> submitLocal({
    required String name,
    required String vehicleType,
    required String vehicleNumber,
    required Map<String, String> documentUrls,
  }) async {
    // Persist locally until dedicated KYC API lands; mark pending for review UI.
    await _store.write(statusKey, 'pending');
    await _store.write('kyc_name', name);
    await _store.write('kyc_vehicle_type', vehicleType);
    await _store.write('kyc_vehicle_number', vehicleNumber);
    await _store.write('kyc_docs', documentUrls.entries.map((e) => '${e.key}=${e.value}').join('|'));
  }
}
