import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_geocam/service/gallery_service.dart';
import 'package:simple_geocam/service/geo_service.dart';

class GeoCamFileMetadata {
  final int sequenceNumberDefault = 1;
  final format = DateFormat("dd-MM-yyyy hh:mm:ssa");
  final GeoService geoService = GeoService();
  final GalleryService galleryService = GalleryService();

  Future<String> getImageName() async {
    final String dateTimeStr = format.format(geoService.getCurrentDateTime());
    final int sequenceNumber = await _getAssetSequenceNumber();
    const String customName01 = 'BySimpleGeoCam';
    const String timeZone = 'GMT+05:30';
    return '$dateTimeStr\_$sequenceNumber\_$customName01\_$timeZone';
  }

  Future<int> _getAssetSequenceNumber() async {
    AssetPathEntity? applicationAlbum = await galleryService.loadApplicationAlbum();
    if (applicationAlbum != null) {
      int assetCount = await applicationAlbum.assetCountAsync;
      return assetCount + 1;
    }
    return sequenceNumberDefault;
  }
}
