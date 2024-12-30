import 'package:flash_note/resources/res_assets.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

// The NoInternetDialog widget is a stateless widget that displays a dialog when there is no internet connection.
class NoInternetDialog extends StatelessWidget {
  // The title of the dialog, default is 'No Internet Connection'.
  final String? title;

  // The subtitle of the dialog, default is 'Please check your internet connection'.
  final String? subtitle;

  // Constructor for the NoInternetDialog widget.
  // It takes two optional parameters, title and subtitle.
  const NoInternetDialog({
    super.key,
    this.title = 'No Internet Connection',
    this.subtitle = 'Please check your internet connection',
  });

  @override
  Widget build(BuildContext context) {
    // The dialog is built with a custom shape and a transparent background.
    return Scaffold(
      backgroundColor: ResColors.black.withOpacity(0.3),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _contentBox(context),
      ),
    );
  }

  // This method builds the content of the dialog.
  Widget _contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: ResColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ResColors.dark, width: 3.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Display an animation from Lottie files.
              LottieBuilder.asset(
                ResAssets.noInternetConnection,
                width: 250.w,
                height: 180.w,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40.h),
              // Display the title of the dialog.
              Text(
                title!,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.w),
              // Display the subtitle of the dialog.
              Text(
                subtitle!,
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22.sp),
            ],
          ),
        ),
      ],
    );
  }
}
