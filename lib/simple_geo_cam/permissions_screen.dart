import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_geocam/constant/ui_theme.dart';
import 'package:simple_geocam/simple_geo_cam/camera_screen.dart';
import 'package:simple_geocam/service/geo_cam_permission_status.dart';

import '../service/permission_service.dart';
import '../service/snack_bar_util.dart';

class PermissionsScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PermissionsScreen({super.key, required this.cameras});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool isPermissionsLoading = true;
  bool isCameraAccess = false;
  bool isMicrophoneAccess = false;
  bool isPhotoLibraryAccess = false;
  bool isLocationAccess = false;
  PermissionService permissionService = PermissionService();
  UITheme uiTheme = UITheme();

  @override
  void initState() {
    super.initState();
    getCurrentPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPermissionsLoading) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'We need some access!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: uiTheme.brandColor800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'You need to grant access to the device camera, microphone and photo library to take photos or record video',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                buildAccessTile(context,
                    icon: Icons.camera_alt,
                    title: 'Camera Access',
                    subtitle: 'Access is necessary to capture photos & Videos for stamping.',
                    onChanged: _cameraAccessOnChanged,
                    isActive: isCameraAccess),
                buildAccessTile(context,
                    icon: Icons.mic,
                    title: 'Microphone Access',
                    subtitle: 'Microphone access is essential for high-quality video recording.',
                    onChanged: _microphoneAccessOnChanged,
                    isActive: isMicrophoneAccess),
                buildAccessTile(context,
                    icon: Icons.photo,
                    title: 'Photo Library Access',
                    subtitle: 'Permission is required to access the photo library on this device.',
                    onChanged: _photoLibraryOnChanged,
                    isActive: isPhotoLibraryAccess),
                buildAccessTile(
                  context,
                  icon: Icons.location_on,
                  title: 'Location Access',
                  subtitle: 'For the accurate location, this app requires permission.',
                  onChanged: _locationAccessOnChanged,
                  isActive: isLocationAccess,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: isCameraAccess && isMicrophoneAccess && isPhotoLibraryAccess && isLocationAccess ? nextButton : null,
                  // Blank method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCameraAccess && isMicrophoneAccess && isPhotoLibraryAccess && isLocationAccess
                        ? uiTheme.brandColor800
                        : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: (isCameraAccess && isMicrophoneAccess && isPhotoLibraryAccess && isLocationAccess)
                            ? uiTheme.textColor
                            : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Show a loading indicator while data is loading
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget buildAccessTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required ValueChanged<bool> onChanged,
      bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: uiTheme.iconOnColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeColor: uiTheme.brandColor800,
          ),
        ],
      ),
    );
  }

  void _cameraAccessOnChanged(bool toggleValue) async {
    if (toggleValue) {
      // Perform asynchronous permission request
      Permission permissionCamera = permissionService.permissionCamera;
      GeoCamPermissionStatus permissionStatus = await permissionService.requirePermission(permission: permissionCamera);
      if (GeoCamPermissionStatus.isAlreadyDenied == permissionStatus) {
        showPermissionDialog(context);
        return;
      }
      // Update the state synchronously
      setState(() {
        if (GeoCamPermissionStatus.isGranted == permissionStatus || GeoCamPermissionStatus.isAlreadyGranted == permissionStatus) {
          isCameraAccess = true;
        } else {
          SnackBarUtil().message(context: context, message: 'Application requires this permission to function properly');
        }
      });
    } else {
      // If permission is denied, prompt the user to open settings
      SnackBarUtil().message(context: context, message: 'To revoke permission please go to system app settings');
    }
  }

  void _microphoneAccessOnChanged(bool toggleValue) async {
    if (toggleValue) {
      Permission permissionMicrophone = permissionService.permissionMicrophone;
      GeoCamPermissionStatus permissionStatus = await permissionService.requirePermission(permission: permissionMicrophone);
      if (GeoCamPermissionStatus.isAlreadyDenied == permissionStatus) {
        showPermissionDialog(context);
        return;
      }
      // Update the state synchronously
      debugPrint('debugPrint >>>>>>>>>>>> 01 microphone status $permissionStatus');
      setState(() {
        if (GeoCamPermissionStatus.isGranted == permissionStatus || GeoCamPermissionStatus.isAlreadyGranted == permissionStatus) {
          isMicrophoneAccess = true;
        } else {
          SnackBarUtil().message(context: context, message: 'Application requires this permission to function properly');
        }
      });
    } else {
      // If permission is denied, prompt the user to open settings
      SnackBarUtil().message(context: context, message: 'To revoke permission please go to system app settings');
    }
  }

  void _photoLibraryOnChanged(bool toggleValue) async {
    if (toggleValue) {
      Permission permissionPhoto = permissionService.permissionPhoto;
      GeoCamPermissionStatus permissionStatus = await permissionService.requirePermission(permission: permissionPhoto);
      if (GeoCamPermissionStatus.isAlreadyDenied == permissionStatus) {
        showPermissionDialog(context);
        return;
      }
      setState(() {
        if (GeoCamPermissionStatus.isGranted == permissionStatus || GeoCamPermissionStatus.isAlreadyGranted == permissionStatus) {
          isPhotoLibraryAccess = true;
        } else {
          SnackBarUtil().message(context: context, message: 'Application requires this permission to function properly');
        }
      });
    } else {
      // If permission is denied, prompt the user to open settings
      SnackBarUtil().message(context: context, message: 'To revoke permission please go to system app settings');
    }
  }

  void _locationAccessOnChanged(bool toggleValue) async {
    if (toggleValue) {
      Permission permissionLocation = permissionService.permissionLocation;
      GeoCamPermissionStatus permissionStatus = await permissionService.requirePermission(permission: permissionLocation);
      if (GeoCamPermissionStatus.isAlreadyDenied == permissionStatus) {
        showPermissionDialog(context);
        return;
      }
      setState(() {
        if (GeoCamPermissionStatus.isGranted == permissionStatus || GeoCamPermissionStatus.isAlreadyGranted == permissionStatus) {
          isLocationAccess = true;
        } else {
          SnackBarUtil().message(context: context, message: 'Application requires this permission to function properly');
        }
      });
    } else {
      // If permission is denied, prompt the user to open settings
      SnackBarUtil().message(context: context, message: 'To revoke permission please go to system app settings');
    }
  }

  /// Function to show a dialog with "Cancel" and "Open Settings"
  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "Application requires this permission. Please grant permission in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Open app settings
              Navigator.of(context).pop(); // Close the dialog
              permissionService.requirePermissionWithSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentPermissionStatus() async {
    isCameraAccess = await permissionService.permissionCamera.status.isGranted;
    isMicrophoneAccess = await permissionService.permissionMicrophone.status.isGranted;
    isPhotoLibraryAccess = await permissionService.permissionPhoto.status.isGranted;
    isLocationAccess = await permissionService.permissionLocation.status.isGranted;
    setState(() {
      isPermissionsLoading = false;
    });
  }

  void nextButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen(cameras: widget.cameras)),
    );
  }
}
