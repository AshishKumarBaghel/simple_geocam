import 'dart:io';
import 'dart:typed_data';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaRepository {
  Uuid uuid = Uuid();

  Future<File> savePhotoBytes(Uint8List bytes) async {
    // Get the temporary directory of the device.
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    // Define the file path and name.
    final File tmpFinalPhoto = File('$tempPath/geo_cam_merged_output_${uuid.v4()}.jpg');

    // Write the bytes to the file.
    await tmpFinalPhoto.writeAsBytes(bytes);
    await _savePhotoToAlbum(tmpFinalPhoto.path);
    return tmpFinalPhoto;
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
