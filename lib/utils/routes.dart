import 'package:flash_note/screens/non_auth/login/login.dart';
import 'package:flash_note/screens/non_auth/sign_up/sign_up.dart';
import 'package:flash_note/screens/splash/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splash = '/';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signUp';
  static const String homeRoute = '/home';
  static const String notesRoute = '/notes';
  static const String noteDetailsRoute = '/noteDetails';
  static const String profileRoute = '/profile';

  static Route<dynamic>? routeCalled(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (context) => const Splash(),
        );
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case Routes.signUpRoute:
        return MaterialPageRoute(
          builder: (context) => const SignUp(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );
      case Routes.notesRoute:
        return MaterialPageRoute(
          builder: (context) => const Notes(),
        );
      case Routes.noteDetailsRoute:
      // Handle noteDetails route with potential arguments
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => NoteDetails(
            noteId: args?['noteId'],
            title: args?['title'],
            content: args?['content'],
          ),
        );
      case Routes.profileRoute:
        return MaterialPageRoute(
          builder: (context) => const Profile(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
    }
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final SlideDirection slideDirection;

  CustomPageRoute({
    required this.child,
    this.slideDirection = SlideDirection.bottom
  }) : super(
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

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

enum SlideDirection { right, left, top, bottom }