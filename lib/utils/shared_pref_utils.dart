import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static SharedPreferences? _prefs;

  /*call this method from iniState() function of mainApp().*/
  static Future<SharedPreferences?> init() async {
    return _prefs = await SharedPreferences.getInstance();
  }

  //sets
  static Future<bool?> setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value);

  static Future<bool?> setDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value);

  static Future<bool?> setInt(String key, int value) async =>
      await _prefs?.setInt(key, value);

  static Future<bool?> setString(String key, String value) async =>
      await _prefs?.setString(key, value);

  static Future<bool?> setStringList(String key, List<String> value) async =>
      await _prefs?.setStringList(key, value);

  //gets
  static bool? getBool(String key) {
    return _prefs?.getBool(key) ?? false;
  }

  static double? getDouble(String key) => _prefs?.getDouble(key);

  static int? getInt(String key) => _prefs?.getInt(key);

  static String? getString(String key) => _prefs?.getString(key);

  static List<String>? getStringList(String key) => _prefs?.getStringList(key);

  //deletes..
  static Future<bool?>? remove(String key) => _prefs?.remove(key);

  static Future<bool?>? clear() => _prefs?.clear();
}

class PrefConst {
  static const PREF_TOKEN = "token";
  static const PREF_USER = "user";
}
