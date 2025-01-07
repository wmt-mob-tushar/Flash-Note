import 'package:flash_note/networking/model/user.dart';

/// selectedLocale : "en"

class AppState {
  String? _selectedLocale;
  String? _token;
  User? _user;
  bool _isOnboardingComplete;

  User? get user => _user;

  String? get selectedLocale => _selectedLocale;

  String? get token => _token;

  bool get isOnboardingComplete => _isOnboardingComplete;

  AppState({
    String? selectedLocale,
    String? token,
    User? user,
    bool isOnboardingComplete = false,
  })  : _selectedLocale = selectedLocale,
        _token = token,
        _user = user,
        _isOnboardingComplete = isOnboardingComplete;

  AppState.fromJson(json)
      : _selectedLocale = json?['selectedLocale'],
        _token = json?['token'],
        _user = json?['user'] != null ? User.fromJson(json['user']) : null,
        _isOnboardingComplete = json?['isOnboardingComplete'] ?? false;

  AppState copyWith({
    String? selectedLocale,
    String? token,
    User? user,
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
