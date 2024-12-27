import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class MediaRepository {
  Future<void> savePhoto(String photoPath) async {
    String albumPath = await getOrCreateDocumentAlbum();
    final File imageFile = File(photoPath);
    final File savedImage = await imageFile.copy('$albumPath/sgc-${DateTime.now().millisecondsSinceEpoch}.jpg');
    await _savePhotoToAlbum(savedImage.path);
    debugPrint('Photo saved to ${savedImage.path}');
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
