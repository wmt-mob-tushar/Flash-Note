import 'dart:math' as math;
import 'dart:ui';
import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonBackground extends StatefulWidget {
  final Widget child;
  final bool showBackground;

  const CommonBackground({
    super.key,
    required this.child,
    this.showBackground = true,
  });

  @override
  State<CommonBackground> createState() => _CommonBackgroundState();
}

class _CommonBackgroundState extends State<CommonBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  Widget animatedBackground() {
    if (!widget.showBackground) return const SizedBox.shrink();

    return Positioned(
      top: 0.5.sh,
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
          maxWidth: 1.5.sw,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
