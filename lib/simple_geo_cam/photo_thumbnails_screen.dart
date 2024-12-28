import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

import 'fullscreen_image_page.dart'; // for Uint8List

class PhotoThumbnailsScreen extends StatefulWidget {
  const PhotoThumbnailsScreen({super.key});

  @override
  _PhotoThumbnailsScreenState createState() => _PhotoThumbnailsScreenState();
}

class _PhotoThumbnailsScreenState extends State<PhotoThumbnailsScreen> {
  bool _isLoading = false;
  List<AssetEntity> _assets = [];

  @override
  void initState() {
    super.initState();
    _loadAssetsFromSpecificAlbum();
  }

  Future<void> _loadAssetsFromSpecificAlbum() async {
    setState(() {
      _isLoading = true;
    });

    // 1. Request permission
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      // Permission denied
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // 2. Fetch list of all albums (images only)
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    // 3. Find the album named "Simple Geo Cam"
    AssetPathEntity? targetAlbum;
    for (var album in albums) {
      if (album.name == "Simple Geo Cam") {
        targetAlbum = album;
        break;
      }
    }

    if (targetAlbum == null) {
      // Album not found
      setState(() {
        _isLoading = false;
      });
      _showAlbumNotFoundDialog();
      return;
    }

    // 4. Fetch the assets (photos) in the found album
    final List<AssetEntity> fetchedAssets = await targetAlbum.getAssetListPaged(
      page: 0,
      size: 1000, // Adjust as needed
    );

    setState(() {
      _assets = fetchedAssets;
      _isLoading = false;
    });
  }

  /// Optional: Show dialog if permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Please grant photo library access in your device settings to view the album.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Optional: Show dialog if album is not found
  void _showAlbumNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Album Not Found'),
          content: const Text('The album "Simple Geo Cam" was not found on this device.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Builds a GridView of thumbnails
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Geo Cam Album'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssetsFromSpecificAlbum,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            onPressed: () => deleteMultipleAssets(_assets),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _assets.isEmpty
              ? const Center(child: Text('No photos found in this album.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _assets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 thumbnails across
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final asset = _assets[index];

                    // We use FutureBuilder to load the thumbnail asynchronously
                    return FutureBuilder<Uint8List?>(
                      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            color: Colors.grey[300],
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            // On tap, navigate to a full-screen image viewer with swiping
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImagePage(
                                  assets: _assets,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  Future<void> deleteMultipleAssets(List<AssetEntity> assets) async {
    try {
      // This will permanently delete them from the device’s photo library
      List<String> assetIds = [];
      for (AssetEntity assetEntity in assets) {
        assetIds.add(assetEntity.id);
      }
      final result = await PhotoManager.editor.deleteWithIds(assetIds);
      if (result.isEmpty) {
        // If delete failed, handle appropriately
        print('Failed to delete assets');
      } else {
        print('Assets deleted successfully');
      }
    } catch (e) {
      print('Error deleting assets: $e');
    } finally {
      _loadAssetsFromSpecificAlbum();
    }
  }
}
