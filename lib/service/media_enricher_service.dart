import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaEnricherService {
  Uuid uuid = Uuid();

  Future<File> mergeImages(File originalFile, String overlayAssetPath) async {
    // Load the original image
    final originalBytes = await originalFile.readAsBytes();
    final img.Image? originalImage = img.decodeImage(originalBytes);
    if (originalImage == null) {
      throw Exception("Could not decode the original image.");
    }

    // Load the overlay from assets
    final overlayBytes = await rootBundle.load(overlayAssetPath);
    final overlayImage = img.decodeImage(overlayBytes.buffer.asUint8List());
    if (overlayImage == null) {
      throw Exception("Could not decode the overlay image.");
    }

    // Calculate position to place overlay at bottom center of the original image
    final xPos = (originalImage.width - overlayImage.width) ~/ 2; // Center horizontally
    final yPos = originalImage.height - overlayImage.height - 10; // Bottom with 10px padding

    // Overlay using compositeImage()
    final mergedImage = img.compositeImage(
      originalImage,
      overlayImage,
      dstX: xPos,
      dstY: yPos,
    );

    // Save the merged image
    final mergedBytes = img.encodeJpg(mergedImage);
    final mergedFile = File('${originalFile.parent.path}/merged_output_${uuid.v4()}.jpg')..writeAsBytesSync(mergedBytes);

    return mergedFile;
  }

  Future<File> captureAndSavePng(GlobalKey previewContainerKey) async {
    // 2. Retrieve the render object of the RepaintBoundary
    RenderRepaintBoundary boundary = previewContainerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // 3. Convert the RepaintBoundary to an image
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);

    // 4. Convert the image to PNG bytes
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final pngBytes = byteData!.buffer.asUint8List();

    // 5. Get a directory to save the image (e.g., documents directory)
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/my_captured_widget_${uuid.v4()}.png';

    // 6. Write the PNG bytes to a file
    final file = File(imagePath);
    File resultPng = await file.writeAsBytes(pngBytes);

    return resultPng;
  }

}
