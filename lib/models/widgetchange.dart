import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProjetController extends GetxController {
  var curentWidget = Container().obs;

  changeWiget(Container widget) => curentWidget.value = widget;
}
