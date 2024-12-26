import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../splash/splash_screen.dart';

class MainScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String packageVersion;

  const MainScreen({super.key, required this.cameras, required this.packageVersion});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Geo Cam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(cameras: cameras, packageVersion: packageVersion),
      //home: CameraSimpleScreen(cameras: cameras),
    );
  }
}
