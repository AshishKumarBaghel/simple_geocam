import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_geocam/simple_geo_cam/camera_screen.dart';
import 'package:simple_geocam/simple_geo_cam/permissions_screen.dart';

import '../service/permission_service.dart';

class SplashScreen extends StatefulWidget {
  List<CameraDescription> cameras;

  SplashScreen({super.key, required this.cameras});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAllPermissions = false;
  PermissionService permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    // After 2 seconds, navigate to HomeScreen
    _loadAllNecessaryPermissions().then((bool allPermissions) {
      Future.delayed(const Duration(seconds: 2), () {
        if (allPermissions) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => CameraScreen(cameras: widget.cameras),
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => PermissionsScreen(cameras: widget.cameras),
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Image.asset(
          'assets/icon/icon_simple_geo_cam.png',
          width: 100, // adjust size as needed
          height: 100,
        ),
      ),
    );
  }

// Load the boolean from shared prefs
  Future<bool> _loadAllNecessaryPermissions() async {
    bool isCameraAccess = await permissionService.permissionCamera.status.isGranted;
    bool isMicrophoneAccess = await permissionService.permissionPhoto.status.isGranted;
    bool isPhotoLibraryAccess = await permissionService.permissionPhoto.status.isGranted;
    bool isLocationAccess = await permissionService.permissionLocation.status.isGranted;
    _isAllPermissions = isCameraAccess && isMicrophoneAccess && isPhotoLibraryAccess; //&& isLocationAccess;
    return _isAllPermissions;
  }
}
