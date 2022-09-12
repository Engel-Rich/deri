import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Themes extends GetxController {
  var theme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  ).obs;
  static const _key = "dark";

  static final _box = GetStorage();

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );

  bool isdark() => _box.read(_key) ?? false;
  save(bool val) => _box.write(_key, val);

  changeTheme() {
    theme.value = isdark() ? light : dark;
  }
}
