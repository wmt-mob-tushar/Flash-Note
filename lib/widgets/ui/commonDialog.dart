import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/utils/validator.dart';
import 'package:flash_note/widgets/ui/app_textFormField.dart';
import 'package:flash_note/widgets/ui/common_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonDialog extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final VoidCallback onConfirm;
  final TextEditingController? inputController;
  final String title;
  final String? subTitle;
  final String confirmButtonText;
  final bool isTextField;
  final String? textInputFieldLabel;

  const CommonDialog({
    super.key,
    required this.onConfirm,
    this.inputController,
    required this.title,
    this.subTitle,
    required this.confirmButtonText,
    this.isTextField = false,
    this.textInputFieldLabel,
    this.formKey,
  });

  @override
  State<CommonDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: ResColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Stack(
          children: [
            //close button
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.highlight_remove_outlined,
                  color: ResColors.black,
                  size: 24.sp,
                ),
              ),
            ),

            //
            Form(
              key: widget.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.subTitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        widget.subTitle ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ResColors.textSecondary,
                        ),
                      ),
                    ),
                  if (widget.isTextField)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: AppTextFormField(
                        controller: widget.inputController,
                        label: widget.textInputFieldLabel,
                        borderColor: ResColors.black,
                        validator: (value) => Validator.customMsg(
                          value,
                          'Please enter a valid Folder name',
                        ),
                      ),
                    ),
                  SizedBox(height: 20.h),
                  CommonAppButton(
                    text: widget.confirmButtonText,
                    onTap: widget.onConfirm,
                    color: ResColors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
