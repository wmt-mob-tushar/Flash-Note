import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBar extends StatelessWidget {
  final String? text;
  final Color? color;
  final Function? onRetry;
  final String? retryText;
  final messageContext;

  const MessageBar({
    @required this.text,
    this.color = ResColors.success,
    this.onRetry,
    this.messageContext,
    this.retryText,
  });

  void _onRetry(BuildContext context) {
    if (onRetry != null) {
      onRetry!();
    }
    OverlaySupportEntry.of(context)?.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.w),
          ),
          margin: EdgeInsets.all(10.w),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    text ?? "",
                    style: TextStyle(color: ResColors.white, fontSize: 14.sp),
                  ),
                ),
              ),
              if (retryText != null)
                Material(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        retryText ?? "",
                        style: TextStyle(
                          color: ResColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    onTap: () => _onRetry(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
