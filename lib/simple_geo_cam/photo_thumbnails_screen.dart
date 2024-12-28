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

  // Add this line to track selected asset IDs
  Set<String> _selectedAssetIds = Set<String>();

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
        title: const Text('Select Photos'),
        actions: [
          if (_selectedAssetIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.select_all_outlined),
              onPressed: _selectAll,
              tooltip: 'Select All',
            ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadAssetsFromSpecificAlbum,
            tooltip: 'Refresh',
          ),
          IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              onPressed: () => deleteSelectedAssets(),
              tooltip: 'Delete',
              color: _selectedAssetIds.isNotEmpty ? Colors.red : Colors.grey),
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
                    final isSelected = _selectedAssetIds.contains(asset.id);

                    return Stack(
                      children: [
                        FutureBuilder<Uint8List?>(
                          future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                color: Colors.grey[300],
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                if (_selectedAssetIds.isNotEmpty) {
                                  // If in selection mode, toggle selection
                                  _toggleSelection(asset.id);
                                } else {
                                  // Navigate to full-screen view
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImagePage(
                                        assets: _assets,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            );
                          },
                        ),
                        // Positioned Checkbox
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              _toggleSelection(asset.id);
                            },
                            child: Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  _toggleSelection(asset.id);
                                },
                                activeColor: Colors.white,
                                checkColor: Colors.blue,
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  Future<void> deleteSelectedAssets() async {
    if (_selectedAssetIds.isEmpty) return;

    try {
      // This will permanently delete them from the device’s photo library
      List<String> assetIds = [];
      final List<String> assetIdsToDelete = _selectedAssetIds.toList();
      final result = await PhotoManager.editor.deleteWithIds(assetIdsToDelete);
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

  void _toggleSelection(String assetId) {
    setState(() {
      if (_selectedAssetIds.contains(assetId)) {
        _selectedAssetIds.remove(assetId);
      } else {
        _selectedAssetIds.add(assetId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedAssetIds.length == _assets.length) {
        // Deselect all
        _selectedAssetIds.clear();
      } else {
        // Select all
        _selectedAssetIds = _assets.map((asset) => asset.id).toSet();
      }
    });
  }
}
