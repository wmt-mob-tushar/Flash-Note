import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/widgets/ui/loader.dart';
import 'package:flash_note/widgets/ui/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

class CommonUtils {
  static void showToast(
      String text, {
        MessageType type = MessageType.SUCCESS,
        Duration duration = const Duration(seconds: 2),
      }) {
    Color? color;
    switch (type) {
      case MessageType.SUCCESS:
        color = ResColors.success;
      case MessageType.FAILED:
        color = ResColors.error;
      case MessageType.INFO:
        color = ResColors.info;
    }
    showOverlayNotification(
          (context) => Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.all(12.h),
          width: 0.9.sw,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(5.r)),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: ResColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      duration: duration,
      position: NotificationPosition.bottom,
    );
  }

  static void showLoading(
    BuildContext context, {
    Color loaderColor = Colors.transparent,
    bool cancelable = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          child: Center(
            child: Loader(
              backgroundColor: loaderColor,
              size: Size.square(24.w),
            ),
          ),
          onWillPop: () async => cancelable,
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
    );
  }

  static void showMessage(
    String? text, {
    MessageType type = MessageType.SUCCESS,
    Function? onRetry,
    String? retryText,
    Duration duration = const Duration(seconds: 2),
  }) {
    Color? color;
    switch (type) {
      case MessageType.SUCCESS:
        color = ResColors.success;
        break;
      case MessageType.FAILED:
        color = ResColors.failed;
        break;
      case MessageType.INFO:
        color = ResColors.info;
        break;
    }
    showOverlayNotification(
      (context) {
        return MessageBar(
          text: text,
          color: color,
          onRetry: onRetry,
          messageContext: context,
          retryText: retryText,
        );
      },
      duration: duration,
      position: NotificationPosition.bottom,
    );
  }

  static String getCurrentLocale() {
    return AppStore.store?.state.selectedLocale ?? "en";
  }
}

class MediaType {
  static const IMAGE = 1;
  static const VIDEO = 2;
}

enum MessageType { SUCCESS, FAILED, INFO }
