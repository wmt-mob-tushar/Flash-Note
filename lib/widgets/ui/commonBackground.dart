import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flash_note/resources/res_colors.dart';

class CommonBackground extends StatefulWidget {
  final Widget child;
  final bool showBackground;
  final bool isAnimated;

  const CommonBackground({
    super.key,
    required this.child,
    this.showBackground = true,
    this.isAnimated = true,
  });

  @override
  State<CommonBackground> createState() => _CommonBackgroundState();
}

class _CommonBackgroundState extends State<CommonBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 60),
        vsync: this,
      )..repeat();
    }
  }

  Widget _staticBackground() {
    return OverflowBox(
      maxHeight: 1.sh,
      maxWidth: 1.5.sw,
      child: Transform.rotate(
        angle: 1,
        child: Container(
          padding: EdgeInsets.all(80.w),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: ResColors.primary, blurRadius: 50, spreadRadius: 70),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: ResColors.secondary,
                    blurRadius: 50,
                    spreadRadius: 100),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: ResColors.white,
                boxShadow: [
                  BoxShadow(
                      color: ResColors.white, blurRadius: 50, spreadRadius: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedBackground() {
    if (!widget.isAnimated || _controller == null) return _staticBackground();

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Transform.rotate(
          angle: (_controller?.value ?? 0) * 2 * math.pi,
          child: child,
        );
      },
      child: _staticBackground(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (widget.showBackground)
          Positioned(
            top: 0.5.sh,
            left: 0,
            right: 0,
            bottom: 0,
            child: _animatedBackground(),
          ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: ResColors.white.withAlpha(100)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: widget.child)],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
