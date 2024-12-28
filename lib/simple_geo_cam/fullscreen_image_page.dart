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

  // Image cache to store loaded images
  final Map<int, Uint8List?> _imageCache = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Set viewportFraction to 0.99 for 1% space between pages
    _pageController = PageController(initialPage: _currentIndex, viewportFraction: 0.9);
    // Preload initial, two before, and two after images
    _preloadImages(_currentIndex);
    _preloadAdjacentImages(_currentIndex);
  }

  /// Preload the image at the specified index and store it in the cache
  Future<void> _preloadImages(int index) async {
    if (index < 0 || index >= widget.assets.length) return;
    if (_imageCache.containsKey(index)) return; // Already cached

    final asset = widget.assets[index];
    try {
      final bytes = await asset.originBytes;
      if (mounted) {
        setState(() {
          _imageCache[index] = bytes;
        });
      }
    } catch (e) {
      // Handle any errors during image loading
      if (mounted) {
        setState(() {
          _imageCache[index] = null;
        });
      }
    }
  }

  /// Preload two images before and after the current index
  void _preloadAdjacentImages(int index) {
    for (int offset = -2; offset <= 2; offset++) {
      if (offset == 0) continue; // Current image is already preloaded
      _preloadImages(index + offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image ${_currentIndex + 1} of ${widget.assets.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.assets.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Preload two before and two after images
          _preloadAdjacentImages(index);
        },
        itemBuilder: (context, index) {
          final cachedImage = _imageCache[index];

          if (cachedImage != null) {
            // Image is cached, display it
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: InteractiveViewer(
                child: Container(
                  margin: const EdgeInsets.only(top:10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.memory(
                        cachedImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );

            /*return InteractiveViewer(
              child: Center(
                child: Image.memory(
                  cachedImage,
                  fit: BoxFit.contain,
                ),
              ),
            );*/
          } else {
            // Image is not cached, show a loading spinner and start loading
            _preloadImages(index); // Start loading the image
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _imageCache.clear();
    super.dispose();
  }
}
