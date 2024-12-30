import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snug_logger/snug_logger.dart';

class TrackActiveDevices extends WidgetsBindingObserver {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  TrackActiveDevices() {
    WidgetsBinding.instance.addObserver(this);
    _initializeDeviceTracking();
  }

  String _sanitizeFirebaseKey(String key) {
    return key.replaceAll(RegExp(r'[.#\$\[\]]'), '_');
  }

  Future<String> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.model}@${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return '${iosInfo.name}@${iosInfo.identifierForVendor}';
      }
    } catch (e) {
      snugLog('Error fetching device ID: $e', logType: LogType.error);
    }
    return '';
  }

  Future<void> _initializeDeviceTracking() async {
    await _addDevice();
  }

  Future<void> _addDevice() async {
    final String deviceId = await _getDeviceId();
    if (deviceId.isEmpty) return;

    final String sanitizedDeviceId = _sanitizeFirebaseKey(deviceId);
    try {
      await _database.child('devices/$sanitizedDeviceId').set({
        'device_id': deviceId.split('@').last,
      });
    } on FirebaseException catch (e) {
      snugLog('Error adding device to database: ${e.code} : ${e.message}', logType: LogType.error);
    } catch (e) {
      snugLog('Error adding device to database: $e', logType: LogType.error);
    }
  }

  Future<void> _removeDevice() async {
    final String deviceId = await _getDeviceId();
    if (deviceId.isEmpty) return;

    final String sanitizedDeviceId = _sanitizeFirebaseKey(deviceId);
    try {
      await _database.child('devices/$sanitizedDeviceId').remove();
    } catch (e) {
      snugLog('Error removing device from database: $e',
          logType: LogType.error);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _addDevice();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _removeDevice();
    }
  }
}
