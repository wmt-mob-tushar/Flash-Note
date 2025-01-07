import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snug_logger/snug_logger.dart';

class LoginBloc {
  final BehaviorSubject<bool> _isPasswordVisible =
      BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<bool> get isPasswordVisible => _isPasswordVisible;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<ApiResponse<AppUser>> _loginResponse =
      BehaviorSubject();

  BehaviorSubject<ApiResponse<AppUser>> get loginResponse => _loginResponse;

  BehaviorSubject<bool> get isLoading => _isLoading;

  void setIsLoading(bool isLoading) {
    _isLoading.sink.add(isLoading);
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.add(!_isPasswordVisible.value);
  }

  Future<void> emailLogin(String email, String password) async {
    try {
      setIsLoading(true);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/${credential.user?.uid ?? ''}');
      final snapshot = await ref.get();
      final value = AppUser.fromJson(snapshot.value);

      final AppUser userData =
          AppUser(email: value.email, uid: value.uid, userName: value.userName);

      _loginResponse.sink.add(ApiResponse.completed(userData));
      setIsLoading(false);
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      _loginResponse.sink.add(ApiResponse.message(e.message ?? ''));
    } catch (e) {
      setIsLoading(false);
      _loginResponse.sink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      setIsLoading(true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'profile',
          'email',
        ],
      ).signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      final AppUser userData = AppUser(
        uid: user?.uid,
        email: user?.email,
        userName: user?.displayName,
      );

      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref('users/${userData.uid ?? ''}');
      await databaseReference.set(userData.toJson());

      setIsLoading(false);
      _loginResponse.sink.add(ApiResponse.completed(userData));
    } catch (e) {
      setIsLoading(false);
      _loginResponse.sink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _isPasswordVisible.close();
  }
}
