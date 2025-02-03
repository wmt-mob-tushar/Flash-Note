import 'package:flash_note/networking/model/app_user.dart';

/// selectedLocale : "en"

class AppState {
  String? _selectedLocale;
  String? _token;
  AppUser? _user;
  bool _isOnboardingComplete;

  AppUser? get user => _user;

  String? get selectedLocale => _selectedLocale;

  String? get token => _token;

  bool get isOnboardingComplete => _isOnboardingComplete;

  AppState({
    String? selectedLocale,
    String? token,
    AppUser? user,
    bool isOnboardingComplete = false,
  })  : _selectedLocale = selectedLocale,
        _token = token,
        _user = user,
        _isOnboardingComplete = isOnboardingComplete;

  AppState.fromJson(json)
      : _selectedLocale = json?['selectedLocale'],
        _token = json?['token'],
        _user = json?['user'] != null ? AppUser.fromJson(json['user']) : null,
        _isOnboardingComplete = json?['isOnboardingComplete'] ?? false;

  AppState copyWith({
    String? selectedLocale,
    String? token,
    AppUser? user,
    bool? isOnboardingComplete,
  }) =>
      AppState(
        selectedLocale: selectedLocale ?? _selectedLocale,
        token: token ?? _token,
        user: user ?? _user,
        isOnboardingComplete: isOnboardingComplete ?? _isOnboardingComplete,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selectedLocale'] = _selectedLocale;
    map['token'] = _token;
    map['user'] = _user?.toJson();
    map['isOnboardingComplete'] = _isOnboardingComplete;
    return map;
  }
}
