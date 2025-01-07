import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/resources/res_assets.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/non_auth/onboarding/bloc/onboarding_bloc.dart';
import 'package:flash_note/screens/non_auth/onboarding/model/onboarding_model.dart';
import 'package:flash_note/utils/routes.dart';
import 'package:flash_note/widgets/ui/animatedCircularButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  final OnboardingBloc _bloc = OnboardingBloc();
  final PageController _pageController = PageController();
  late AnimationController _buttonAnimationController;
  late AnimationController _illustrationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: 'Welcome to Flash Note',
      subtitle: 'The best way to take notes and stay organized',
      imagePath: ResAssets.onboarding1,
      backgroundColor: ResColors.primary,
    ),
    OnboardingItem(
      title: 'Organize your notes',
      subtitle: 'Keep your notes organized and easy to find',
      imagePath: ResAssets.onboarding2,
      backgroundColor: ResColors.secondary,
    ),
    OnboardingItem(
      title: 'Stay productive',
      subtitle: 'Stay productive and never forget a thing',
      imagePath: ResAssets.onboarding3,
      backgroundColor: ResColors.primary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _pageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    final page = _pageController.page!.round();
    _bloc.updatePage(page);
    _illustrationController.forward(from: 0.0);
  }

  void _setupAnimations() {
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _illustrationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _illustrationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _illustrationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
  }

  void skipOnboarding() {
    _pageController.animateToPage(
      onboardingItems.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void redirectToNextPage() {
    if (_bloc.currentPage.value == onboardingItems.length - 1) {
      Navigator.pushReplacementNamed(
        context,
        Routes.loginRoute,
      );
      AppStore.store?.dispatch(
        StoreAction(data: true, type: ActionType.isOnboardingComplete),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: ResColors.dark,
      body: StreamBuilder<int>(
        stream: _bloc.currentPage.stream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: SizedBox(
                      height: 0.6.sh,
                      width: 1.sw,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (page) => _bloc.updatePage(page),
                        itemCount: onboardingItems.length,
                        itemBuilder: (context, index) {
                          final item = onboardingItems[index];
                          return ColoredBox(
                            color: item.backgroundColor.withAlpha(200),
                            child: AnimatedBuilder(
                              animation: _illustrationController,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        item.imagePath,
                                        height: 0.4.sh,
                                        width: 0.8.sw,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      child: GestureDetector(
                        onTap: skipOnboarding,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 5.h,
                          ),
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: ResColors.white,
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            l10n?.tapToSkip ?? '',
                            style: TextStyle(
                              color: ResColors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AnimatedBuilder(
                    animation: _illustrationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Text(
                                onboardingItems[snapshot.data ?? 0].title,
                                style: TextStyle(
                                  color: ResColors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                onboardingItems[snapshot.data ?? 0].subtitle,
                                style: TextStyle(
                                  color: ResColors.white.withAlpha(200),
                                  fontSize: 16.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              AnimatedCircularButton(
                size: 100.w,
                currentPage: snapshot.data ?? 0,
                totalPages: onboardingItems.length,
                onTap: redirectToNextPage,
              ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _illustrationController.dispose();
    _bloc.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top left
    path.lineTo(0, size.height - 60);

    // Create a gentle curve
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height - 60,
    );

    // Complete the path
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
