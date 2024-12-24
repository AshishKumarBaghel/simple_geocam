import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:simple_geocam/service/geo_cam_permission_status.dart';

class PermissionService {
  Permission permissionCamera = Permission.camera;
  Permission permissionPhoto = Platform.isIOS ? Permission.photos : Permission.storage;
  Permission permissionLocation = Permission.locationWhenInUse;

  Future<GeoCamPermissionStatus> requirePermission({required Permission permission}) async {
    var status = await permission.status; // Initial permission status
    if (status.isGranted) {
      return GeoCamPermissionStatus.isAlreadyGranted; // Return the granted status directly
    } else if (status.isDenied) {
      final requestStatus = await permission.request(); // Request permission
      if (requestStatus.isGranted) {
        return GeoCamPermissionStatus.isGranted;
      }
      return GeoCamPermissionStatus.isDenied; // Return the updated status
    } else if (status.isLimited) {
      return GeoCamPermissionStatus.isLimited;
    } else {
      return GeoCamPermissionStatus.isAlreadyDenied; // Return the initial status if it's not explicitly denied
    }
  }

  Future<void> requirePermissionWithSettings() => openAppSettings();
}
