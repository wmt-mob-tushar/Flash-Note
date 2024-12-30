import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flash_note/resources/res_colors.dart';

class Loader extends StatefulWidget {
  final Color? backgroundColor;
  final double? strokeWidth;
  final double? value;
  final Size size;

  const Loader({
    this.backgroundColor = ResColors.white,
    this.strokeWidth,
    this.value,
    this.size = const Size(18, 18),
  });

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: CircularProgressIndicator(
        value: widget.value,
        backgroundColor: widget.backgroundColor,
        strokeWidth: widget.strokeWidth ?? 3.w,
      ),
    );
  }
}
