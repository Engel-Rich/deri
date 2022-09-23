// import 'dart:io';

import 'package:deri/interfaces/app/application.dart';
import 'package:deri/interfaces/app/authuser.dart';
import 'package:deri/interfaces/app/theme.dart';
import 'package:deri/services/Theme_services.dart';

import 'package:deri/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';

Future<void> firebasebackground(RemoteMessage message) async {
  
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebasebackground);
  runApp(DeriAfrica());
  const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
}

class DeriAfrica extends StatelessWidget {
  DeriAfrica({Key? key}) : super(key: key);
  final themeController = Get.put(ThemeServices());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: StoreBinding(),
      themeMode: ThemeServices().theme,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: StreamBuilder<User?>(
          stream: authentication.authStateChanges(),
          builder: (context, snapshot) {
            return snapshot.data == null
                ? const LoginPage()
                : const Application(page: 0);
          }),
    );
  }
}
