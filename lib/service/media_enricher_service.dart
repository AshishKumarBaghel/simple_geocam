import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaEnricherService {
  final Uuid uuid = Uuid();

//3024 4032
//720 1280
  Future<File> mergeImages(File originalFile, File overlayOriginalFile) async {
    // Load the original image
    final originalBytes = await originalFile.readAsBytes();
    final img.Image? originalImage = img.decodeImage(originalBytes);
    if (originalImage == null) {
      throw Exception("Could not decode the original image.");
    }
    // Load the overlay from assets
    final overlayBytes = await overlayOriginalFile.readAsBytes();
    img.Image? overlayImage = img.decodeImage(overlayBytes.buffer.asUint8List());
    if (overlayImage == null) {
      throw Exception("Could not decode the overlay image.");
    }

    // Scale overlay image based on original image size
    const overlayScaleFactor = 1; // Overlay will be 20% of the original image width
    final scaledOverlayWidth = (originalImage.width * overlayScaleFactor).toInt();
    final scaledOverlayHeight = (overlayImage.height * (scaledOverlayWidth / overlayImage.width)).toInt();
    overlayImage = img.copyResize(overlayImage, width: scaledOverlayWidth, height: scaledOverlayHeight);

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
    final mergedFile = File('${originalFile.parent.path}/geo_cam_merged_output_${uuid.v4()}.jpg')..writeAsBytesSync(mergedBytes);

    return mergedFile;
  }

  Future<File> captureAndSavePng(GlobalKey previewContainerKey) async {
    // Retrieve the RepaintBoundary render object
    RenderRepaintBoundary boundary = previewContainerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Dynamically determine the pixelRatio based on the device
    final mediaQuery = MediaQuery.of(previewContainerKey.currentContext!);
    double pixelRatio = mediaQuery.devicePixelRatio;

    // Convert the RepaintBoundary to an image
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

    // Convert the image to PNG bytes
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to convert the image to PNG bytes.");
    }
    final pngBytes = byteData.buffer.asUint8List();

    // Get a directory to save the image (e.g., documents directory)
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/geo_cam_captured_widget_${uuid.v4()}.png';

    // Write the PNG bytes to a file
    final file = File(imagePath);
    File resultPng = await file.writeAsBytes(pngBytes);

    return resultPng;
  }

  Future<Uint8List> mergeImagesBytes(Uint8List originalBytes, Uint8List overlayBytes) async {
    // Load the original image
    //final originalBytes = await originalFile.readAsBytes();
    final img.Image? originalImage = img.decodeImage(originalBytes);
    if (originalImage == null) {
      throw Exception("Could not decode the original image.");
    }
    // Load the overlay from assets
    //final overlayBytes = await overlayOriginalFile.readAsBytes();
    img.Image? overlayImage = img.decodeImage(overlayBytes.buffer.asUint8List());
    if (overlayImage == null) {
      throw Exception("Could not decode the overlay image.");
    }

    // Scale overlay image based on original image size
    const overlayScaleFactor = 1; // Overlay will be 20% of the original image width
    final scaledOverlayWidth = (originalImage.width * overlayScaleFactor).toInt();
    final scaledOverlayHeight = (overlayImage.height * (scaledOverlayWidth / overlayImage.width)).toInt();
    overlayImage = img.copyResize(overlayImage, width: scaledOverlayWidth, height: scaledOverlayHeight);

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
    return img.encodeJpg(mergedImage);
  }

  Future<Uint8List> captureAndSavePngBytes(GlobalKey previewContainerKey) async {
    // Retrieve the RepaintBoundary render object
    RenderRepaintBoundary boundary = previewContainerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Dynamically determine the pixelRatio based on the device
    final mediaQuery = MediaQuery.of(previewContainerKey.currentContext!);
    double pixelRatio = mediaQuery.devicePixelRatio;

    // Convert the RepaintBoundary to an image
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

    // Convert the image to PNG bytes
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to convert the image to PNG bytes.");
    }
    return byteData.buffer.asUint8List();
  }
}
