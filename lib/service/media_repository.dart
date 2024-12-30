import 'dart:io';
import 'dart:typed_data';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_geocam/service/geo_cam_file_metadata.dart';
import 'package:uuid/uuid.dart';

class MediaRepository {
  final Uuid uuid = Uuid();
  final GeoCamFileMetadata fileMetadataService = GeoCamFileMetadata();

  Future<File> savePhotoBytes(Uint8List bytes) async {
    // Get the temporary directory of the device.
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    // Define the file path and name.
    final String finalFileName = await fileMetadataService.getImageName();
    final File tmpFinalPhoto = File('$tempPath/$finalFileName.jpg');

    // Write the bytes to the file.
    await tmpFinalPhoto.writeAsBytes(bytes);
    await _savePhotoToAlbum(tmpFinalPhoto.path);
    return tmpFinalPhoto;
  }

  Future<void> _savePhotoToAlbum(String filePath) async {
    await GallerySaver.saveImage(filePath, albumName: 'Simple Geo Cam');
  }
}
