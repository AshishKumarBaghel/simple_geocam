import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../ui_widget/thumbnail_item.dart';
import 'fullscreen_image_page.dart'; // for Uint8List

class PhotoThumbnailsScreen extends StatefulWidget {
  const PhotoThumbnailsScreen({super.key});

  @override
  PhotoThumbnailsScreenState createState() => PhotoThumbnailsScreenState();
}

class PhotoThumbnailsScreenState extends State<PhotoThumbnailsScreen> {
  bool _isLoading = false;
  List<AssetEntity> _assets = [];

  // Track selected asset IDs
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

    // Request permission
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      setState(() {
        _isLoading = false;
      });
      _showPermissionDeniedDialog();
      return;
    }

    // Fetch list of all albums (images only)
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    // Find the album named "Simple Geo Cam"
    AssetPathEntity? targetAlbum;
    for (var album in albums) {
      if (album.name == "Simple Geo Cam") {
        targetAlbum = album;
        break;
      }
    }

    if (targetAlbum == null) {
      setState(() {
        _isLoading = false;
      });
      _showAlbumNotFoundDialog();
      return;
    }

    // Fetch the assets (photos) in the found album
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
            color: _selectedAssetIds.isNotEmpty ? Colors.red : Colors.grey,
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
                    final isSelected = _selectedAssetIds.contains(asset.id);

                    return ThumbnailItem(
                      asset: asset,
                      isSelected: isSelected,
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
                      onCheckboxTap: () => _toggleSelection(asset.id),
                    );
                  },
                ),
    );
  }

  Future<void> deleteSelectedAssets() async {
    if (_selectedAssetIds.isEmpty) return;

    try {
      // This will permanently delete them from the device’s photo library
      final List<String> assetIdsToDelete = _selectedAssetIds.toList();
      debugPrint('>>>>>>>>>>debhugh 01');
      final result = await PhotoManager.editor.deleteWithIds(assetIdsToDelete);
      debugPrint('>>>>>>>>>>debhugh 02 $result');
      if (result.isEmpty) {
        // If delete failed, handle appropriately
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete selected photos.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected photos deleted successfully.')),
        );
      }
    } catch (e) {
      print('Error deleting assets: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while deleting photos.')),
      );
    } finally {
      _selectedAssetIds.clear();
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
        _selectedAssetIds.clear();
      } else {
        _selectedAssetIds = _assets.map((asset) => asset.id).toSet();
      }
    });
  }
}
