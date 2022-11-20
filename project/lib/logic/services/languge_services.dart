import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LangugeServices {
  final _boxs = GetStorage();
  final _key = 'isAmharic';
  _saveLangugeToBox(bool isAmharic) => _boxs.write(_key, isAmharic);

  bool _loadLangugeFromBox() {
    return _boxs.read(_key) ?? false;
  }

  Locale get local => _loadLangugeFromBox()
      ? const Locale('en', 'US')
      : const Locale('et', 'ET');
  void switchLanguge() {
    Get.updateLocale(_loadLangugeFromBox()
        ? const Locale('et', 'ET')
        : const Locale('en', 'US'));
    _saveLangugeToBox(!_loadLangugeFromBox());
  }
}
