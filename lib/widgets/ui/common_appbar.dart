import 'dart:ui';

import 'package:flash_note/l10n/l10n.dart';
import 'package:flash_note/resources/res_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasDrawer;
  final Widget? leading;
  final VoidCallback? leadingOnPressed;
  final List<Widget>? actions;

  const CommonAppbar({
    super.key,
    this.hasDrawer = false,
    this.leading,
    this.leadingOnPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            // Slight transparency for blur
            border: Border(
              bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.5,),
            ),
          ),
          padding: EdgeInsets.only(top: 26.h, left: 10.w, right: 10.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: leadingOnPressed ??
                    (hasDrawer
                        ? () => Scaffold.of(context).openDrawer()
                        : () => Navigator.of(context).pop()),
                child: SvgPicture.asset(
                  hasDrawer ? ResAssets.menuIcon : ResAssets.backArrow,
                  width: 40.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
              if (leading != null) leading!,
              SizedBox(width: 6.w),
              Text(
                hasDrawer
                    ? l10n?.menu.toUpperCase() ?? ""
                    : l10n?.back.toUpperCase() ?? "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(90.h);
}
