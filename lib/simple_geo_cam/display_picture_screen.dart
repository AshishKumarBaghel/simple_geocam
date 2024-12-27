import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String widgetImagePath;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.widgetImagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Photo')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Image.file(File(widgetImagePath)),
        ],
      ),
    );
  }
}
