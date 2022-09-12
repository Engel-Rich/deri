import 'package:deri/interfaces/app/application.dart';
import 'package:deri/interfaces/app/authuser.dart';
import 'package:deri/interfaces/app/theme.dart';
import 'package:deri/services/Theme_services.dart';

import 'package:deri/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  runApp(DeriAfrica());
}

class DeriAfrica extends StatelessWidget {
  DeriAfrica({Key? key}) : super(key: key);
  final themeController = Get.put(ThemeServices());
  final theme = Get.put(Themes());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialBinding: StoreBinding(),
      // themeMode: themeController.theme,
      theme: theme.theme.value,
      // darkTheme: Themes.dark,
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