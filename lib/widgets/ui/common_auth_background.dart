import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAuthBackground extends StatelessWidget {
  final Widget child;
  final String title;

  const CommonAuthBackground({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 0.5.sh,
          width: 1.sw,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ResColors.primary,
                ResColors.secondary,
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 42.sp,
                fontWeight: FontWeight.w900,
              ),
            ),*/
            SizedBox(height: 20.h),
            Container(
              decoration: const BoxDecoration(
                color: ResColors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 0.8.sh,
              width: 1.sw,
              child: child,
            ),
          ],
        )
      ],
    );
  }
}
