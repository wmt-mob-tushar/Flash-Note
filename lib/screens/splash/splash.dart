import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flash_note/resources/res_assets.dart';
import 'package:flash_note/utils/routes.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000)).then(
      (value) => Navigator.popAndPushNamed(context, Routes.Login),
    );

    return Image.asset(
      ResAssets.logo,
      width: 1.sw,
      height: 1.sh,
      fit: BoxFit.fitHeight,
    );
  }
}
