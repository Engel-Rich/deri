import 'package:deri/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
// Notification pluguin
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // rx dart for initialise Notification
  static final onNotifications = BehaviorSubject<String?>();

  //dislay notification
  static Future swoNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        await notificationDetails(),
      );

  // ajouter l'action sur la notification
  static Future swoNotificationAfther(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime time}) async =>
      flutterLocalNotificationsPlugin.show(
          id, title, body, await notificationDetails());

// notificationdetail
  static  notificationDetails(
          {StyleInformation? styleInformation})  =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel Id",
          "channel Name",
          channelDescription: 'teste de la notification',
          icon: "@mipmap/ic_launcher",
          playSound: true,
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails(),
      );

  // init methode for initialisation
  static Future init({bool initNotif = false}) async {
    initialisation();
  }

// android initialisation
  static AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  static BuildContext? context;

  // Ios initialisation
  static IOSInitializationSettings iosInitializationSettings =
      const IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // initialisations settigns
  static InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosInitializationSettings);

  // Ios receive methode
  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
        context: context!,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title!, style: styletitle),
            content: texter(body ?? "Notification"),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: texter(
                    "Ok",
                  )),
            ],
          );
        });
  }

  static void selectNotification(String? payload) async {
    onNotifications.add(payload);
  }

  static initialisation() {
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }
}
