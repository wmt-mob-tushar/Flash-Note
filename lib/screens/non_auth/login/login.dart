import 'dart:ui';

import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/screens/non_auth/login/bloc/login_bloc.dart';
import 'package:flash_note/utils/validator.dart';
import 'package:flash_note/widgets/ui/common_auth_background.dart';
import 'package:flash_note/widgets/view/app_textFormField/app_textFormField.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginBloc _bloc = LoginBloc();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: CommonAuthBackground(
        title: 'Login',
        child: Column(
          children: [
            const Text('Login'),

            AppTextFormField(
              label: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validator.email(value, l10n),
            ),
          ],
        ),
      ),
    );
  }
}
