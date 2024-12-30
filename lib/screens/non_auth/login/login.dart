import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_note/screens/non_auth/login/bloc/login_bloc.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_store.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final LoginBloc _bloc = LoginBloc();

  @override
  void initState() {
    super.initState();
  }

  void changeLanguage() {
    AppStore.store?.dispatch(
      StoreAction(
        type: ActionType.ChangeLocale,
        data: AppLocalizations.of(context)?.localeName == "en" ? "it" : "en",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)?.helloWorld ?? 'Hello World',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Change Language",
        onPressed: changeLanguage,
        child: const Icon(Icons.language),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
