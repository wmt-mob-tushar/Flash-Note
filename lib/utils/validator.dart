import 'package:flash_note/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validator {
  static String? email(String? value, AppLocalizations? l10n) {
    if (value?.isEmpty ?? true) {
      return l10n?.enterEmail ?? "";
    }
    if (!Regex.EMAIL.hasMatch(value ?? "")) {
      return l10n?.invalidEmailId ?? "";
    }

    return null;
  }

  static String? emailOptional(String value, AppLocalizations? l10n) {
    if (value.isEmpty) {
      return null;
    }
    if (!Regex.EMAIL.hasMatch(value)) {
      return l10n?.invalidEmailId ?? "";
    }

    return null;
  }

  static String? password(String? value, AppLocalizations? l10n) {
    if (value?.isEmpty ?? true) {
      return l10n?.enterPassword ?? "";
    }
    if (!Regex.PASSWORD.hasMatch(value ?? "")) {
      return l10n?.passwordValidation ?? "";
    }

    return null;
  }

  static String? passwordSignIn(String? value, AppLocalizations? l10n) {
    if (value?.isEmpty ?? true) {
      return l10n?.enterPassword ?? "";
    }

    return null;
  }

  static String? confirmPassword(
    String? value,
    String? password,
    AppLocalizations? l10n,
  ) {
    if (value?.isEmpty ?? true) {
      return l10n?.enterConfirmPassword ?? "";
    }
    if (value != password) {
      return l10n?.passwordDoesNotMatch ?? "";
    }
    return null;
  }

  static String? name(String? value, AppLocalizations? l10n) {
    if (value?.isEmpty ?? true) {
      return l10n?.enterUserName ?? "";
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
