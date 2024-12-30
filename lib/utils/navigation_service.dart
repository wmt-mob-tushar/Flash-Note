import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static final NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future? navigateToReplacement(String rn, {Object? arguments}) {
    return navigationKey.currentState
        ?.pushReplacementNamed(rn, arguments: arguments);
  }

  Future? navigateTo(String rn, {Object? arguments}) {
    return navigationKey.currentState?.pushNamed(rn, arguments: arguments);
  }

  Future? navigateToRoute(MaterialPageRoute rn) {
    return navigationKey.currentState?.push(rn);
  }

  Future? resetToRoute(String rn) {
    return navigationKey.currentState
        ?.pushNamedAndRemoveUntil(rn, (r) => false);
  }

/*goBack() {
    return navigationKey.currentState.pop();
  }*/
}
