import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sugam_ecommerce/Views/productListPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: 'assets/splash.png',
        nextScreen: ProductListPage(),
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.fade,
        splashIconSize: MediaQuery.of(context).size.height / 2,
        duration: 1000,
      ),
    );
  }
}
