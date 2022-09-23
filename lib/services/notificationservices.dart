import 'package:deri/services/notification.dart';
import 'package:deri/variables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  String token = "";
  void requestPermission() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
      debugPrint('Token $token');
      saveToken(authentication.currentUser!.uid);
    });
  }

  saveToken(userId) async {
    await tokenCollections.doc(userId).set({'token': token});
  }

  initInfos() {
    NotificationApi.flutterLocalNotificationsPlugin.initialize(
      NotificationApi.initializationSettings,
      onSelectNotification: (payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
          } else {}
        } catch (e) {}
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      final detail = NotificationApi.notificationDetails(
          styleInformation: bigTextStyleInformation);
      await NotificationApi.flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        detail,
        payload: message.data['body'],
      );
    });
  }
}
