import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_geocam/preference/general_preference_service.dart';
import 'package:simple_geocam/simple_geo_cam/main_screen.dart';
import 'package:simple_geocam/template/template_preference_service.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  MobileAds.instance.initialize();
  await TemplatePreferenceService.init();
  await GeneralPreferenceService.init();
  // Lock to portrait up/down only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Fetch package information
  final packageInfo = await PackageInfo.fromPlatform();
  final String packageVersion = packageInfo.version;

  runApp(MainScreen(cameras: cameras, packageVersion: packageVersion));
}
