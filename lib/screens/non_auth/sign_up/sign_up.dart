import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/app_user.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/screens/non_auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:flash_note/utils/common_utils.dart';
import 'package:flash_note/utils/routes.dart';
import 'package:flash_note/utils/validator.dart';
import 'package:flash_note/widgets/ui/app_textFormField.dart';
import 'package:flash_note/widgets/ui/common_app_button.dart';
import 'package:flash_note/widgets/ui/common_auth_background.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snug_logger/snug_logger.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignupBloc _bloc = SignupBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.signupResponse.listen(signupHandler);
  }

  void signupHandler(ApiResponse<AppUser> value) {
    if (value.status == Status.COMPLETED) {
      snugLog("Signup success");
      CommonUtils.showToast(context.l10n?.signupSuccess ?? '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homeRoute,
        (route) => false,
      );
      AppStore.store
          ?.dispatch(StoreAction(type: ActionType.SetUser, data: value.data));
    } else if (value.status == Status.MESSAGE) {
      CommonUtils.showToast(value.message ?? '', type: MessageType.FAILED);
    } else if (value.status == Status.ERROR) {
      snugLog("Error while signup ${value.message}");
    }
  }

  void onSignUpTap() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      _bloc.signUpEmail(
        _emailController.text.trim(),
        _userNameController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CommonAuthBackground(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  Text(
                    l10n?.signUp ?? '',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  AppTextFormField(
                    controller: _userNameController,
                    label: l10n?.userName ?? '',
                    prefixIcon: Icons.account_circle,
                    validator: (value) => Validator.name(value, l10n),
                  ),
                  SizedBox(height: 24.h),
                  AppTextFormField(
                    controller: _emailController,
                    label: l10n?.email ?? '',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => Validator.email(value, l10n),
                  ),
                  SizedBox(height: 24.h),
                  StreamBuilder<bool>(
                    stream: _bloc.isPasswordVisible.stream,
                    builder: (context, snapshot) {
                      return AppTextFormField(
                        controller: _passwordController,
                        label: l10n?.password ?? '',
                        isPassword: snapshot.data ?? false,
                        prefixIcon: Icons.lock,
                        suffixWidget: GestureDetector(
                          onTap: () => _bloc.togglePasswordVisibility(),
                          child: Icon(
                            snapshot.data ?? false
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) =>
                            Validator.password(value, l10n),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  CommonAppButton(
                    text: l10n?.signUp ?? '',
                    onTap: onSignUpTap,
                  ),
                  SizedBox(height: 32.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: l10n?.dontHaveAnAccount ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                      children: [
                        WidgetSpan(child: SizedBox(width: 4.w)),
                        TextSpan(
                          text: l10n?.login ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
