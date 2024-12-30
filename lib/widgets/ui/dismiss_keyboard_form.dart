import 'package:flutter/material.dart';

class DismissKeyboardForm extends StatelessWidget {
  final Widget child;

  // Use this widget to automatically dismiss the keyboard when the user taps inside or outside the form.
  // It's helpful for improving the user experience in forms.
  const DismissKeyboardForm({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      // When the user taps inside the widget, dismiss the keyboard
      onTapInside: (event) => FocusScope.of(context).unfocus(),
      // When the user taps outside the widget, dismiss the keyboard
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
