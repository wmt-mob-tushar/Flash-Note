import 'package:flutter/material.dart';

class Routes {
  static const String splash = '/';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signUp';
  static const String homeRoute = '/home';
  static const String notesRoute = '/notes';
  static const String noteDetailsRoute = '/noteDetails';
  static const String profileRoute = '/profile';
  static const String onBoardingRoute = '/onBoarding';
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final SlideDirection slideDirection;

  CustomPageRoute(
      {required this.child, this.slideDirection = SlideDirection.bottom})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            late Offset begin;
            const end = Offset.zero;
            const curve = Curves.ease;

            switch (slideDirection) {
              case SlideDirection.left:
                begin = const Offset(-1, 0);
              case SlideDirection.right:
                begin = const Offset(1, 0);
              case SlideDirection.bottom:
                begin = const Offset(0, 1);
              case SlideDirection.top:
                begin = const Offset(0, -1);
            }

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return ClipRect(
             clipBehavior: Clip.hardEdge,
              child: SlideTransition(
                position: animation.drive(tween),
                child: child,
              ),
            );
          },
        );
}

enum SlideDirection { right, left, top, bottom }
