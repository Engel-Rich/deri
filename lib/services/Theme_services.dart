// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices extends GetxController {
  final _box = GetStorage();
  final _key = "dark";
  saveThemeinBox(bool isdark) => _box.write(_key, isdark);
  bool _chargerLeThemeDeLaBox() => _box.read(_key) ?? false;
  ThemeMode get theme =>
      _chargerLeThemeDeLaBox() ? ThemeMode.dark : ThemeMode.light;

  changeTheme() {
    Get.changeThemeMode(
        _chargerLeThemeDeLaBox() ? ThemeMode.dark : ThemeMode.light);
    saveThemeinBox(!_chargerLeThemeDeLaBox());
  }
}

class StoreBinding implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeServices());
  }
}
