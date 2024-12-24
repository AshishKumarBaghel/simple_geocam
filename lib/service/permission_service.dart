import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_geocam/service/geo_cam_permission_status.dart';

class PermissionService {
  Permission permissionCamera = Permission.camera;
  Permission permissionMicrophone = Permission.microphone;
  Permission permissionPhoto = Platform.isIOS ? Permission.photos : Permission.storage;
  Permission permissionLocation = Permission.location;

  Future<GeoCamPermissionStatus> requirePermission({required Permission permission}) async {
    var status = await permission.status; // Initial permission status
    if (status.isGranted) {
      return GeoCamPermissionStatus.alreadyGranted; // Return the granted status directly
    } else if (status.isDenied) {
      final requestStatus = await permission.request(); // Request permission
      debugPrint('>>>>>>>>>>>>>> permission requested = $requestStatus');
      if (requestStatus.isGranted) {
        return GeoCamPermissionStatus.granted;
      }
      return GeoCamPermissionStatus.denied; // Return the updated status
    } else {
      return GeoCamPermissionStatus.alreadyDenied; // Return the initial status if it's not explicitly denied
    }
  }

  Future<void> requirePermissionWithSettings() => openAppSettings();
}
