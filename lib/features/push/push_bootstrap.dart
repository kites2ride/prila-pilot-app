import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/features/push/data/devices_repository.dart';

/// Optional FCM — no-ops when Firebase platform config files are missing.
Future<void> bootstrapPush(WidgetRef ref) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    await ref.read(devicesRepositoryProvider).syncPermissions(
          notificationPermission: granted ? 'granted' : 'denied',
        );
    if (!granted) return;
    final token = await messaging.getToken();
    if (token == null || token.isEmpty) return;
    await ref.read(devicesRepositoryProvider).registerPushToken(
          pushToken: token,
          platform: Platform.isIOS ? 'ios' : 'android',
        );
    FirebaseMessaging.onMessage.listen((_) {});
  } catch (e) {
    if (kDebugMode) {
      debugPrint('FCM skipped (add google-services / plist later): $e');
    }
  }
}
