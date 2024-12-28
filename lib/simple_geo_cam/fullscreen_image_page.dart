import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<AssetEntity> assets;
  final int initialIndex;

  const FullScreenImagePage({super.key, required this.assets, required this.initialIndex});

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    // Preload initial and adjacent images for smoother experience
    _preloadImages(_currentIndex);
    _preloadImages(_currentIndex + 1);
    _preloadImages(_currentIndex - 1);
  }

  /// Preload images to enhance performance
  Future<void> _preloadImages(int index) async {
    if (index < 0 || index >= widget.assets.length) return;

    final asset = widget.assets[index];
    await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
    await asset.originBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Image ${_currentIndex + 1} of ${widget.assets.length}'),
        //backgroundColor: Colors.black,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.assets.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Preload adjacent images
          _preloadImages(index + 1);
          _preloadImages(index - 1);
        },
        itemBuilder: (context, index) {
          final asset = widget.assets[index];
          return FutureBuilder<Uint8List?>(
            // Load full-size image data
            future: asset.originBytes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return InteractiveViewer(
                child: Center(
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
