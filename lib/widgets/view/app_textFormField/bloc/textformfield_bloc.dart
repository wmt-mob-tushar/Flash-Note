import 'package:rxdart/rxdart.dart';

class TextFieldBloc {
  final BehaviorSubject<bool> _isPasswordVisible = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isPasswordVisible => _isPasswordVisible.stream;

  bool get isPasswordVisibleValue => _isPasswordVisible.value;

  void togglePasswordVisibility() {
    _isPasswordVisible.add(!_isPasswordVisible.value);
  }

  void dispose() {
    _isPasswordVisible.close();
  }
}