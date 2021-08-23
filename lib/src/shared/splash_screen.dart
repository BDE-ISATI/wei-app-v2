import 'package:flutter/material.dart';
import 'package:isati_integration/utils/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colorPrimary,
        child: const Center(
          child:Image (
            image: AssetImage('assets/images/logo_white.png'),
            height: 128,
          ),
        ),
      ),
    );
  }
}