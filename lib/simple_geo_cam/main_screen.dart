import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../splash/splash_screen.dart';

class MainScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MainScreen({super.key, required this.cameras});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Geo Cam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(cameras: cameras),
      //home: CameraSimpleScreen(cameras: cameras),
    );
  }
}
