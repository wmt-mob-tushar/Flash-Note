import 'dart:ui';
import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flash_note/utils/routes.dart';
import 'package:flash_note/resources/res_colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  late Animation<Offset> _positionAnimation1;
  late Animation<Offset> _positionAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation1 = Tween<double>(
      begin: 0.2,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation2 = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _positionAnimation1 = Tween<Offset>(
      begin: const Offset(-0.5, -0.5),
      end: const Offset(0.3, 0.3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _positionAnimation2 = Tween<Offset>(
      begin: const Offset(0.5, 0.5),
      end: const Offset(-0.3, -0.3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500)).then(
        (_) => Navigator.pushReplacementNamed(
          context,
          AppStore.store!.state.isOnboardingComplete
              ? Routes.loginRoute
              : Routes.onBoardingRoute,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: ResColors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              SlideTransition(
                position: _positionAnimation1,
                child: Transform.scale(
                  scale: _scaleAnimation1.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ResColors.primary.withAlpha(100),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _positionAnimation2,
                child: Transform.scale(
                  scale: _scaleAnimation2.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ResColors.secondary.withAlpha(100),
                    ),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: ResColors.black.withAlpha(100),
                ),
              ),
              // Centered text with glass effect
              Center(
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n?.flash ?? '',
                        style: TextStyle(
                          fontSize: 100.sp,
                          fontFamily: FontFamily.tertiary,
                          color: ResColors.white,
                        ),
                      ),
                      Text(
                        l10n?.note ?? '',
                        style: TextStyle(
                          fontSize: 100.sp,
                          color: ResColors.white,
                          fontFamily: FontFamily.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
