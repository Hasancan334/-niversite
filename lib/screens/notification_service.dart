import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // İzin iste
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Token al
    String? token = await _messaging.getToken();
    print('📱 FCM Token: $token');

    // Local notifications başlat
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings),
    );

    // Channel oluştur
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Bildirimler',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Topic'lere abone ol
    await _messaging.subscribeToTopic('all');

    print('✅ Bildirim hazır');
  }
}