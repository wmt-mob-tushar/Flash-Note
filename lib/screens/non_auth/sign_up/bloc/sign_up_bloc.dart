import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/app_user.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc {
  final BehaviorSubject<bool> _isPasswordVisible =
  BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<bool> get isPasswordVisible => _isPasswordVisible;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<ApiResponse<AppUser>> _signupResponse =
  BehaviorSubject();

  BehaviorSubject<ApiResponse<AppUser>> get signupResponse => _signupResponse;

  BehaviorSubject<bool> get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading.sink.add(value);
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.add(!_isPasswordVisible.value);
  }

  Future<void> signUpEmail(
      String email, String username, String password) async {
    try {
      setIsLoading(true);
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final AppUser userData = AppUser(
        uid: credential.user?.uid,
        userName: username,
        email: email,
      );

      final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('users/${userData.uid}');
      await databaseReference.set(userData.toJson());

      _signupResponse.sink.add(ApiResponse.completed(userData));
      setIsLoading(false);
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      _signupResponse.sink.add(ApiResponse.message(e.message ?? ''));
    } catch (e) {
      setIsLoading(false);
      _signupResponse.sink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _isLoading.close();
    _signupResponse.close();
  }
}
