import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_geocam/simple_geo_cam/main_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // Lock to portrait up/down only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Fetch package information
  final packageInfo = await PackageInfo.fromPlatform();
  final String packageVersion = packageInfo.version;

  runApp(MainScreen(cameras: cameras, packageVersion: packageVersion));
}
