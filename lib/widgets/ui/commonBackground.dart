import 'dart:math' as math;
import 'dart:ui';
import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/resources/res_assets.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonBackground extends StatefulWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final void Function()? leadingOnPressed;
  final bool isDrawer;
  final String title;
  final Widget child;

  const CommonBackground({
    super.key,
    this.actions,
    this.leading,
    this.isDrawer = false,
    this.leadingOnPressed,
    this.title = '',
    required this.child,
  });

  @override
  State<CommonBackground> createState() => _CommonBackgroundState();
}

class _CommonBackgroundState extends State<CommonBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  Widget animatedBackground() {
    return Positioned(
      top: 0.6.sh,
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: OverflowBox(
          maxHeight: 1.sh,
          maxWidth: 1.8.sw,
          child: Transform(
            transform: Matrix4.rotationZ(0.5),
            alignment: Alignment.center,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ResColors.primary,
                    blurRadius: 50,
                    spreadRadius: 70,
                  ),
                ],
              ),
              padding: EdgeInsets.all(80.w),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ResColors.secondary,
                      blurRadius: 50,
                      spreadRadius: 100,
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: ResColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: ResColors.white,
                        blurRadius: 50,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        animatedBackground(),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: ResColors.white.withAlpha(100),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //TODO: Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.leadingOnPressed ??
                          (widget.isDrawer
                              ? () => Scaffold.of(context).openDrawer()
                              : () => Navigator.of(context).pop()),
                      child: SvgPicture.asset(
                        widget.isDrawer
                            ? ResAssets.menuIcon
                            : ResAssets.backArrow,
                        width: 40.w,
                      ),
                    ),
                    if (widget.leading != null) widget.leading!,
                    SizedBox(width: 6.w),
                    Text(
                      widget.isDrawer ? l10n?.menu ?? "" : l10n?.back ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    if (widget.actions != null) ...widget.actions!,
                  ],
                ),
              ),
              //TODO: Body
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
