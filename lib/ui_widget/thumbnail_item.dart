import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ThumbnailItem extends StatefulWidget {
  final AssetEntity asset;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onCheckboxTap;

  const ThumbnailItem({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.onTap,
    required this.onCheckboxTap,
  });

  @override
  _ThumbnailItemState createState() => _ThumbnailItemState();
}

class _ThumbnailItemState extends State<ThumbnailItem> {
  Uint8List? _thumbnailData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchThumbnail();
  }

  Future<void> _fetchThumbnail() async {
    setState(() {
      _isLoading = true;
    });

    final data = await widget.asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));

    if (mounted) {
      setState(() {
        _thumbnailData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: _isLoading
              ? Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : _thumbnailData != null
                  ? Image.memory(
                      _thumbnailData!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Container(
                      color: Colors.grey[300],
                    ),
        ),
        // Positioned Checkbox
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: widget.onCheckboxTap,
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: widget.isSelected,
                onChanged: (bool? value) {
                  widget.onCheckboxTap();
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
  }
}
