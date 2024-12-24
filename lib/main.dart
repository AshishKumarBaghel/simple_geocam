import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:simple_geocam/simple_geo_cam/main_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MainScreen(cameras: cameras));
}
