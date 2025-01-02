import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final String? type;
  final String? label;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixWidget;
  final bool readOnly;
  final bool enabled;
  final TextEditingController? controller;
  final String? hintText;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final String? value;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? initialValue;
  final Key? formFiledKey;
  final IconData? prefixIcon;
  final Color? hintColor;
  final Color? borderColor;
  final Color textColor;
  final bool isPassword;
  final FocusNode? focusNode;
  final VoidCallback? onPasswordVisibilityToggle;

  const AppTextFormField({
    super.key,
    this.type,
    this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixWidget,
    this.readOnly = false,
    this.enabled = true,
    this.controller,
    this.hintText,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.value,
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.formFiledKey,
    this.prefixIcon,
    this.hintColor,
    this.borderColor,
    this.textColor =  ResColors.white,
    this.isPassword = false,
    this.focusNode,
    this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFiledKey,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      initialValue: controller == null ? initialValue : null,
      style: TextStyle(
        color: textColor,
        fontSize: 16.sp,
      ),
      readOnly: readOnly,

      enabled: enabled,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: isPassword ? 1 : maxLines,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        hintStyle: TextStyle(
          color: hintColor?.withAlpha(700) ?? textColor.withAlpha(700),
          fontSize: 14.sp,
        ),
        labelStyle: TextStyle(
          color: textColor,
          fontSize: 14.sp,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: textColor,
        )
            : null,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isPassword ? Icons.visibility : Icons.visibility_off,
            color: textColor,
          ),
          onPressed: onPasswordVisibilityToggle,
        )
            : suffixWidget != null
            ? IconTheme(
          data: IconThemeData(color: textColor),
          child: suffixWidget!,
        )
            : null,
        errorStyle: TextStyle(
          color: ResColors.error,
          fontSize: 12.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: borderColor ?? textColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: borderColor ?? ResColors.white,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color:  ResColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: ResColors.error,
            width: 2,
          ),
        ),
        enabled: enabled,
        isDense: true,
      ),
    );
  }
}