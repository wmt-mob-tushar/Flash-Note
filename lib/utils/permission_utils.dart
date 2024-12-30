import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static void textButtonPressed(BuildContext context) {
    Navigator.pop(context, false);
    openAppSettings();
  }

  static Future<bool?> dailLogCalled(BuildContext context, String? msg) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: Text(
            "$msg",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () => PermissionUtils.textButtonPressed(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> checkStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;

      if (status.isDenied) {
        status = await Permission.storage.request();
      }
      if (status.isPermanentlyDenied) {
        return PermissionUtils.dailLogCalled(
            context, "Please give permission from settings to access storage.");
      }

      return status.isGranted;
    } else {
      return true;
    }
  }

  static Future<bool?> checkCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      return PermissionUtils.dailLogCalled(
          context, "Please give permission from settings to capture image.");
    }

    return status.isGranted;
  }

  static Future<bool?> checkMicPermission(BuildContext context) async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    if (status.isPermanentlyDenied) {
      return PermissionUtils.dailLogCalled(
          context, "Please give permission from settings to capture image.");
    }

    return status.isGranted;
  }

  static Future<bool?> checkContactPermission(BuildContext context) async {
    var status = await Permission.contacts.status;

    if (status.isDenied) {
      status = await Permission.contacts.request();
    }
    if (status.isPermanentlyDenied) {
      return PermissionUtils.dailLogCalled(context,
          "flash_note requires contacts access to save contacts to phone.");
    }

    return status.isGranted;
  }
}
