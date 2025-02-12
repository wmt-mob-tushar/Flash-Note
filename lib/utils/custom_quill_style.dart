import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

DefaultStyles customQuillStyles() {
  return DefaultStyles(
    paragraph: DefaultTextBlockStyle(
      TextStyle(
        fontFamily: FontFamily.primary,
        fontSize: 16.sp,
        color: ResColors.textPrimary,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing(6,0),
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    h1: DefaultTextBlockStyle(
      TextStyle(
        fontFamily: FontFamily.primary,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: ResColors.textPrimary,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing(6,0),
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    h2: DefaultTextBlockStyle(
      TextStyle(
        fontFamily: FontFamily.primary,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: ResColors.textPrimary,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing(6,0),
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    h3: DefaultTextBlockStyle(
      TextStyle(
        fontFamily: FontFamily.primary,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: ResColors.textPrimary,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing(6,0),
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    bold: TextStyle(
      fontWeight: FontWeight.bold,
      color: ResColors.textPrimary,
      fontFamily: FontFamily.primary,
    ),
    italic: TextStyle(
      fontStyle: FontStyle.italic,
      color: ResColors.textPrimary,
      fontFamily: FontFamily.primary,
    ),
    underline: TextStyle(
      decoration: TextDecoration.underline,
      color: ResColors.textPrimary,
      fontFamily: FontFamily.primary,
    ),
    strikeThrough: TextStyle(
      decoration: TextDecoration.lineThrough,
      color: ResColors.textPrimary,
      fontFamily: FontFamily.primary,
    ),
    sizeSmall: TextStyle(
      fontSize: 12.sp,
      color: ResColors.textPrimary,
      fontFamily: FontFamily.primary,
    ),
    sizeLarge: TextStyle(
      fontSize: 18.sp,
      color: ResColors.textPrimary,
      fontFamily: FontFamily.primary,
    ),
    sizeHuge: TextStyle(
      fontSize: 24.sp,
      color: ResColors.textPrimary,
    ),
    placeHolder: DefaultTextBlockStyle(
      TextStyle(
        fontFamily: FontFamily.primary,
        fontSize: 16.sp,
        color: ResColors.textPrimary,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing(6,0),
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    quote: DefaultTextBlockStyle(
      TextStyle(
        fontFamily: FontFamily.primary,
        fontSize: 16.sp,
        color: ResColors.textPrimary,
      ),
      HorizontalSpacing.zero,
      VerticalSpacing(6,0),
      VerticalSpacing.zero,
      BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 4.sp,
            color: ResColors.textPrimary,
          ),
        ),
      ),
    ),
  );
}

QuillSimpleToolbarConfigurations toolbarConfigurations({
  void Function()? onDropPressed,
}) {
  return QuillSimpleToolbarConfigurations(
    multiRowsDisplay: false,
    showSubscript: false,
    showSuperscript: false,
    fontFamilyValues: const {
      'Archivo': FontFamily.primary,
      'Poppins': FontFamily.primary,
    },
    buttonOptions: QuillSimpleToolbarButtonOptions(
      base: const QuillToolbarBaseButtonOptions(
        iconTheme: QuillIconTheme(
          iconButtonSelectedData: IconButtonData(
            color: ResColors.white,
          ),
          iconButtonUnselectedData: IconButtonData(
            color: ResColors.white,
          ),
        ),
      ),
      undoHistory: const QuillToolbarHistoryButtonOptions(
        iconTheme: QuillIconTheme(
          iconButtonUnselectedData: IconButtonData(
              style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          )),
        ),
      ),
      redoHistory: const QuillToolbarHistoryButtonOptions(
        iconTheme: QuillIconTheme(
          iconButtonUnselectedData: IconButtonData(
              style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          )),
        ),
      ),
      fontSize: QuillToolbarFontSizeButtonOptions(
        afterButtonPressed: onDropPressed,
        style: const TextStyle(
          color: ResColors.white,
          fontFamily: FontFamily.primary,
        ),
      ),
      fontFamily: QuillToolbarFontFamilyButtonOptions(
        style: const TextStyle(
          color: ResColors.white,
        ),
        afterButtonPressed: onDropPressed,
      ),
      clipboardPaste: const QuillToolbarToggleStyleButtonOptions(
        iconTheme: QuillIconTheme(
          iconButtonUnselectedData: IconButtonData(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
          ),
        ),
      ),
      selectHeaderStyleDropdownButton:
          QuillToolbarSelectHeaderStyleDropdownButtonOptions(
        afterButtonPressed: onDropPressed,
        textStyle: const TextStyle(
          color: ResColors.white,
        ),
      ),
      clipboardCopy: const QuillToolbarToggleStyleButtonOptions(
        iconTheme: QuillIconTheme(
          iconButtonUnselectedData: IconButtonData(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
          ),
        ),
      ),
      clipboardCut: const QuillToolbarToggleStyleButtonOptions(
        iconTheme: QuillIconTheme(
          iconButtonUnselectedData: IconButtonData(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
          ),
        ),
      ),
    ),
    decoration: BoxDecoration(
      color: ResColors.black,
      borderRadius: BorderRadius.circular(10.r),
    ),
  );
}
