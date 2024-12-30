import 'package:flash_note/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Note',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ResColors.primary,
          surface: ResColors.white,
        ),
        primarySwatch: ResColors.primarySwatch,
        useMaterial3: true,
      ),
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
