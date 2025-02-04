import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/networking/api_response.dart';
import 'package:flash_note/networking/model/app_user.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_store.dart';
import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/screens/non_auth/login/bloc/login_bloc.dart';
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

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginBloc _bloc = LoginBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.loginResponse.listen(loginHandler);
  }

  void loginHandler(ApiResponse<AppUser> value) {
    if (value.status == Status.COMPLETED) {
      CommonUtils.showToast(context.l10n?.loginSuccess ?? '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homeRoute,
        (route) => false,
      );
      AppStore.store?.dispatch(StoreAction(type: ActionType.SetUser, data: value.data));
    } else if (value.status == Status.MESSAGE) {
      CommonUtils.showToast(value.message ?? '', type: MessageType.FAILED);
    } else if (value.status == Status.ERROR) {
      snugLog("Error while login ${value.message}");
    }
  }

  Future<void> onLoginTap() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      _bloc.emailLogin(
        _emailController.text.trim(),
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
                    l10n?.login ?? '',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: ResColors.textPrimary,
                    ),
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
                            color: ResColors.black,
                          ),
                        ),
                        validator: (value) =>
                            Validator.passwordSignIn(value, l10n),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  CommonAppButton(
                    text: l10n?.login ?? '',
                    onTap: onLoginTap,
                  ),
                  SizedBox(height: 24.h),
                  // TODO: Add social login buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                ResColors.black.withAlpha(200),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n?.or ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Container(
                          height: 1.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ResColors.black.withAlpha(200),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildSocialLoginButtons(),
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
                          text: l10n?.signUp ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, Routes.signUpRoute),
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

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CommonAppButton(
                onTap: () => _bloc.signInWithGoogle(),
                text: context.l10n?.singInWithGoogle ?? '',
                textColor: ResColors.black,
                isOutlined: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}