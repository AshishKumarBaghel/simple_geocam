import 'package:photo_manager/photo_manager.dart';

class GalleryService {
  Future<AssetPathEntity?> loadApplicationAlbum() async {
    // Request permission
    AssetPathEntity? targetAlbum;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      return targetAlbum;
    }

    // Fetch list of all albums (images only)
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.all);

    // Find the album named "Simple Geo Cam"
    for (var album in albums) {
      if (album.name == 'Simple Geo Cam') {
        targetAlbum = album;
        break;
      }
    }
    return targetAlbum;
  }
}
