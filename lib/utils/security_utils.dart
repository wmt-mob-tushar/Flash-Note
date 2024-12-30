import 'dart:io';

import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SecurityUtils {
  final JailbreakRootDetection _rootDetection = JailbreakRootDetection.instance;

  // Non-static method to check if the device is rooted
  Future<bool> isDeviceCompromised() async {
    bool isTampered = false;
    final isJailBroken = await _rootDetection.isJailBroken;
    final isNotTrust = await _rootDetection.isNotTrust;
    final isRealDevice = await _rootDetection.isRealDevice;
    final isOnExternalStorage = await _rootDetection.isOnExternalStorage;
    final checkForIssues = await _rootDetection.checkForIssues;

    // Check if the device has any root issues
    final hasRootIssues = checkForIssues.contains(JailbreakIssue.cydiaFound) ||
        checkForIssues.contains(JailbreakIssue.tampered) ||
        checkForIssues.contains(JailbreakIssue.onExternalStorage) ||
        checkForIssues.contains(JailbreakIssue.unknown);

    if (Platform.isIOS) {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final bundleId = packageInfo
          .packageName; // Ex: final bundleId = 'com.w3conext.jailbreakRootDetectionExample'
      isTampered = await JailbreakRootDetection.instance.isTampered(bundleId);
    }

    return isJailBroken ||
        isNotTrust ||
        !isRealDevice ||
        isOnExternalStorage ||
        hasRootIssues ||
        isTampered;
  }

  // Static method to check if the device is in dev mode
  Future<bool> isDevModeOn() async {
    return await _rootDetection.isDevMode;
  }
}
