import 'package:flash_note/utils/constants.dart';

class Validator {
  static String? email(String value) {
    if (value.isEmpty) {
      return 'Please enter email.';
    }
    if (!Regex.EMAIL.hasMatch(value)) {
      return 'Please enter valid email.';
    }

    return null;
  }

  static String? emailOptional(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (!Regex.EMAIL.hasMatch(value)) {
      return 'Please enter valid email.';
    }

    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (!Regex.PASSWORD.hasMatch(value)) {
      return "Please enter valid password.";
    }

    return null;
  }

  static String? passwordSignIn(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  static String? confirmPassword(String value, String password) {
    if (password.isEmpty) {
      return null;
    }
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (value != password) {
      return "Password does not match.";
    }

    return null;
  }

  static String? customMsg(String value, String? msg) {
    if (value.trim().isEmpty) {
      return '$msg';
    }

    return null;
  }
}
