import 'package:flash_note/resources/res_colors.dart';
import 'package:flash_note/widgets/ui/commonBackground.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResColors.background,
      drawer: const Drawer(),
      body: CommonBackground(
          isDrawer: true,
          child: Container(
      
      ),),
    );
  }
}
