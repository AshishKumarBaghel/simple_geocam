import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaRepository {
  Uuid uuid = Uuid();

  Future<void> savePhoto(String photoPath) async {
    String albumPath = await getOrCreateDocumentAlbum();
    final File imageFile = File(photoPath);
    final File savedImage = await imageFile.copy('$albumPath/sgc-${DateTime.now().millisecondsSinceEpoch}.jpg');
    await _savePhotoToAlbum(savedImage.path);
    debugPrint('Photo saved to ${savedImage.path}');
  }

  Future<void> savePhotoBytes(Uint8List bytes) async {
    // Get the temporary directory of the device.
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    // Define the file path and name.
    final File file = File('$tempPath/geo_cam_merged_output_${uuid.v4()}.jpg');

    // Write the bytes to the file.
    await file.writeAsBytes(bytes);
    await _savePhotoToAlbum(file.path);
  }

  Future<String> getOrCreateDocumentAlbum() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory albumDir = Directory('${appDocDir.path}/\'Simple Geo Cam\'');
    if (!await albumDir.exists()) {
      await albumDir.create(recursive: true);
    }
    return albumDir.path;
  }

  Future<void> _savePhotoToAlbum(String filePath) async {
    bool? success = await GallerySaver.saveImage(filePath, albumName: 'Simple Geo Cam');
    if (success != null && success) {
      print('Photo saved to Photos app in the album "Simple Geo Cam"');
    } else {
      print('Failed to save photo to Photos app');
    }
  }
}
