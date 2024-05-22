import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          print('notification payload: ${response.payload}');
        }
        // Handle notification tap
      },
    );

    _createNotificationChannel();
  }

  static void _createNotificationChannel() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channelId', // id
      'channelName', // name
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void showNotification(String title, String body) {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId', // Must match the channel id used in the channel creation
        'channelName',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
