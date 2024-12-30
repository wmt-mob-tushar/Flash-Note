import 'dart:async';

import 'package:flash_note/utils/common_utils.dart';
import 'package:flash_note/widgets/ui/no_internet_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:overlay_support/overlay_support.dart';

// This class is responsible for checking the internet connection status of the device.
class ConnectionChecker {
  // Constants for the connection status messages and titles to be displayed in the app UI overlay dialog box.
  final String _noInternetTxt = "No Internet Connection";
  final String _noInternetSubtitleTxt = "Please check your internet connection";
  final String _connectionBackTxt = "Connected";

  // Instance of Connectivity for listening to connectivity changes.
  final Connectivity _connectivity = Connectivity();

  // Flag to check if the app has started or not.
  bool isAppStarted = false;

  // Overlay dialog instance to show the connection status.
  OverlaySupportEntry? overLayDialog;

  // Variable to store the last connection status.
  String _lastConnectionStatus = "";

  // Singleton instance of the ConnectionChecker class.
  static final ConnectionChecker _singleton = ConnectionChecker._internal();

  // Factory constructor to return the singleton instance.
  factory ConnectionChecker() => _singleton;

  // Private constructor to initialize the singleton instance.
  ConnectionChecker._internal() {
    isAppStarted = true;
    // Listen to connectivity changes and handle them.
    _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) =>
          _handleConnectivityChange(result.first),
    );
  }

  // Method to handle connectivity changes.
  void _handleConnectivityChange(ConnectivityResult result) {
    // Check if the device is connected to the internet.
    final bool isConnected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;

    // If the device is connected and the app is not started, show the connection status.
    if (isConnected && !isAppStarted) {
      _showConnectionStatus(_connectionBackTxt);
      isAppStarted = true;
    }
    // If the device is not connected, show the no internet connection status.
    else if (!isConnected) {
      _showConnectionStatus(_noInternetTxt, true);
      isAppStarted = false;
    }
  }

  // Method to show the connection status.
  void _showConnectionStatus(String message, [bool? hasRetry = false]) {
    // Determine the message type based on the connection status.
    final MessageType type =
        message == _noInternetTxt ? MessageType.FAILED : MessageType.SUCCESS;

    // If the connection status has changed, show the new status.
    if (message != _lastConnectionStatus) {
      // If the device is connected, dismiss the overlay dialog and show the success message.
      if (message == _connectionBackTxt) {
        overLayDialog?.dismiss();
        CommonUtils.showMessage(message, type: type);
      }
      // If the device is not connected and the app is started, show the no internet connection dialog.
      else if (isAppStarted) {
        Future.delayed(const Duration(seconds: 1), () {
          overLayDialog = showOverlay(
            (context, progress) => NoInternetDialog(
              title: _noInternetTxt,
              subtitle: _noInternetSubtitleTxt,
            ),
            duration: Duration.zero,
          );
        });
      }
      // If the device is not connected and the app is not started, show the no internet connection dialog.
      else {
        overLayDialog = showOverlay(
          (context, progress) => NoInternetDialog(
            title: _noInternetTxt,
            subtitle: _noInternetSubtitleTxt,
          ),
          duration: Duration.zero,
        );
      }

      // Update the last connection status.
      _lastConnectionStatus = message;
    }
  }
}
