import 'dart:io';

import 'package:flash_note/utils/common_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ApiConst {
  static Future<Map<String, dynamic>> getCommonHeader() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final Map<String, dynamic> headers = {};
    if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      headers["device-token"] = iosDeviceInfo.identifierForVendor;
      headers["device-type"] = "ios";
      headers["device-name"] = iosDeviceInfo.name;
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      headers["device-token"] = androidDeviceInfo.id;
      headers["device-type"] = "android";
      headers["device-name"] = androidDeviceInfo.model;
    }
    final NetworkInfo networkInfo = NetworkInfo();
    headers["ip-address"] = await networkInfo.getWifiIP();

    headers["lang"] = CommonUtils.getCurrentLocale();
    headers["Accept"] = "application/json";
    return headers;
  }
}

class BaseUrl {
  //Local
  // static const DOMAIN = "";
  // static const COMMON_DOMAIN = "";
  //DEv
  // static const COMMON_DOMAIN = "";
  // static const DOMAIN = "";
  //Prod
  static const COMMON_DOMAIN = "";
  static const DOMAIN =
      "https://www.example.com"; // replace with your domain name here e.g https://www.example.com

  static const API = DOMAIN + "/api/v1";
  static const STORAGE = DOMAIN + "/storage/";

  static getBaseUrl() {
    return API;
  }
}
