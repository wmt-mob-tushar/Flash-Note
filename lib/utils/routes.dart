import 'package:flash_note/screens/non_auth/login/login.dart';
import 'package:flash_note/screens/non_auth/sign_up/sign_up.dart';
import 'package:flash_note/screens/splash/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String notes = '/notes';
  static const String noteDetails = '/noteDetails';
  static const String profile = '/profile';

  Route<dynamic>? routeCalled(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const Splash());
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const Login());
      case Routes.signup:
        return MaterialPageRoute(builder: (context) => const SignUp());
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold());
    }
  }
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
          break;
        case SlideDirection.right:
          begin = const Offset(1, 0);
          break;
        case SlideDirection.bottom:
          begin = const Offset(0, 1);
          break;
        case SlideDirection.top:
          begin = const Offset(0, -1);
          break;
      }

      var tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

enum SlideDirection { right, left, top, bottom }