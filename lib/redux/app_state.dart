import 'package:flash_note/networking/model/user.dart';

/// selectedLocale : "en"

class AppState {
  String? _selectedLocale;
  String? _token;
  User? _user;

  User? get user => _user;

  String? get selectedLocale => _selectedLocale;

  String? get token => _token;

  AppState({
    String? selectedLocale,
    String? token,
    User? user,
  }) {
    _selectedLocale = selectedLocale;
    _token = token;
    _user = user;
  }

  AppState.fromJson(json) {
    if (json != null) {
      _selectedLocale = json['selectedLocale'];
      _token = json['token'];
      _user = json['user'] != null ? User.fromJson(json['user']) : null;
    }
  }

  AppState copyWith({
    String? selectedLocale,
    Wrapper<String?>? token,
    Wrapper<User?>? user,
  }) =>
      AppState(
        selectedLocale: selectedLocale ?? _selectedLocale,
        token: token != null ? token.value : _token,
        user: user != null ? user.value : _user,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selectedLocale'] = _selectedLocale;
    map['token'] = _token;
    map['user'] = _user?.toJson();
    return map;
  }
}

// This is user set the null values to the model class.
class Wrapper<T> {
  final T value;

  Wrapper.value(this.value);
}
