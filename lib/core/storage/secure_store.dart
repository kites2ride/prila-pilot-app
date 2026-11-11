import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

class SecureStore {
  SecureStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const bootstrapCacheKey = 'bootstrap_cache';
  static const permissionsDoneKey = 'permissions_done';
  static const profileDoneKey = 'profile_done';
  static const updatePromptedKey = 'update_prompted_build';

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);
  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> clearSession() async {
    await delete(accessTokenKey);
    await delete(refreshTokenKey);
  }
}
