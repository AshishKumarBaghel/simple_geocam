import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data'; // for Uint8List

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

    // 2. Fetch list of all albums (images only, but you can do RequestType.all if you want videos too)
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    // 3. Find the album we want (e.g., "Camera" or "Recent")
    AssetPathEntity? targetAlbum;
    for (var album in albums) {
      // Adjust this matching logic to your desired album name
      if (album.name == "Simple Geo Cam") {
        targetAlbum = album;
        break;
      }
    }

    if (targetAlbum == null) {
      // If we didn't find a matching album, handle accordingly
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // 4. Fetch the assets (photos) in the found album
    //    Adjust 'size' as needed; if the album is large, consider pagination
    final List<AssetEntity> fetchedAssets = await targetAlbum.getAssetListPaged(
      page: 0,
      size: 1000,
    );

    setState(() {
      _assets = fetchedAssets;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Thumbnails'),
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
                      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)), // thumbnail size
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            color: Colors.grey[300],
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            // On tap, navigate to a full-screen image viewer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImagePage(asset: asset),
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
}

class FullScreenImagePage extends StatelessWidget {
  final AssetEntity asset;

  const FullScreenImagePage({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      // .originBytes loads the full-size image data
      future: asset.originBytes,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Full Image')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Full Image')),
          body: Center(
            child: Image.memory(snapshot.data!),
          ),
        );
      },
    );
  }
}
