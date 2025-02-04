import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final Color? color;
  final bool isOutlined;
  final bool? isLoading;
  final Color? textColor;

  const CommonAppButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.color,
    this.isOutlined = false,
    this.isLoading = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Container(
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : color ?? ResColors.secondary,
            borderRadius: BorderRadius.circular(8.r),
            border: isOutlined
                ? Border.all(
                    color: color ?? ResColors.black,
                    width: 1.w,
                  )
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? ResColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
