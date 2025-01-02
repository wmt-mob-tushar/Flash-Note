import 'package:flash_note/screens/non_auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final SignUpBloc _bloc = SignUpBloc();


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
