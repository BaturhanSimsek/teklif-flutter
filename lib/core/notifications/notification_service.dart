import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'device_token_repository.dart';

part 'notification_service.g.dart';

// Arka planda gelen mesajları işle (top-level function zorunlu)
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Firebase zaten initialize edilmiş durumda
}

@riverpod
NotificationService notificationService(NotificationServiceRef ref) =>
    NotificationService(ref.watch(deviceTokenRepositoryProvider));

class NotificationService {
  NotificationService(this._tokenRepo);

  final DeviceTokenRepository _tokenRepo;

  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'teklif_high',
    'Teklif Bildirimleri',
    description: 'Teklif onay ve durum bildirimleri',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    // Arka plan handler'ı kaydet
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Local notifications — Android kanalı oluştur
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Ön planda gelen bildirimler → local notification olarak göster
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Bildirime tıklandığında uygulama açılıyorsa
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Uygulama kapalıyken bildirime tıklanmış
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _handleNotificationTap(initial);
  }

  Future<void> requestPermissionAndRegisterToken() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    // iOS APNs token (gerekli)
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.getAPNSToken();
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _tokenRepo.updateDeviceToken(token);

    // Token yenilenince otomatik güncelle
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _tokenRepo.updateDeviceToken(newToken);
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;

    _localNotifications.show(
      message.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['quoteId'],
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    // TODO: go_router ile teklif detayına yönlendir
    // final quoteId = message.data['quoteId'];
    // if (quoteId != null) router.push('/quotes/$quoteId');
  }

  void _onNotificationTap(NotificationResponse response) {
    // Local notification'a tıklandı
    // final quoteId = response.payload;
    // if (quoteId != null) router.push('/quotes/$quoteId');
  }
}
