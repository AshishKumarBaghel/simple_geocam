import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_geocam/service/media_enricher_service.dart';
import 'package:simple_geocam/transport/geo_cam_transport.dart';

import '../advertisement/admob_banner_ad.dart';
import '../service/geo_service.dart';
import '../ui_widget/camera_button.dart';
import 'display_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras; // List of available cameras
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool frontCameraToggle = false;
  GeoService geoService = GeoService();
  MediaEnricherService mediaEnricherService = MediaEnricherService();
  ResolutionPreset resolutionPreset = ResolutionPreset.medium;

  // 1. Create a GlobalKey
  final GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _controller = CameraController(
      widget.cameras.first, // The camera to use
      resolutionPreset, // Resolution preset
      enableAudio: false, // Disable audio recording
    );

    initializeCamera(controller: _controller);
  }

  void initializeCamera({required CameraController controller}) {
    // Initialize the controller. This returns a Future.
    _initializeControllerFuture = controller.initialize().then((_) {
      // Lock the camera preview orientation to portrait (for example)
      controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

      // Now the camera preview will *not rotate* automatically
      setState(() {});
    }).catchError((error) {
      print('Error initializing camera: $error');
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GeoCamTransport geoCamTransport = geoService.fetchGeoCamDetails();
    double parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Camera Preview
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Positioned.fill(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.previewSize?.height ?? 0,
                            height: _controller.value.previewSize?.width ?? 0,
                            child: CameraPreview(_controller),
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                // Top Icons
                Positioned(
                  top: 40,
                  width: parentWidth,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.flash_on_outlined, color: Colors.white)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.location_off_outlined, color: Colors.white)),
                        IconButton(
                            onPressed: frontCameraToggleOnPressed,
                            icon: Icon(Icons.camera_front_outlined, color: getIconButtonColor(frontCameraToggle))),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.camera_outlined, color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                // Bottom Section
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RepaintBoundary(
                        key: _previewContainerKey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  geoCamTransport.addressTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  geoCamTransport.address,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lat ${geoCamTransport.lat}, Long ${geoCamTransport.lon}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  geoService.format.format(geoCamTransport.dateTime.toLocal()),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Note: ${geoCamTransport.note}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 13, bottom: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              children: [
                                Icon(Icons.photo_library, color: Colors.white),
                                Text('Collection',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            const Column(
                              children: [
                                Icon(Icons.map, color: Colors.white),
                                Text('Map Data',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            CameraButton(
                              size: 56,
                              onPressed: cameraButtonOnPressed,
                            ),
                            const Column(
                              children: [
                                Icon(Icons.file_present, color: Colors.white),
                                Text('File Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            const Column(
                              children: [
                                Icon(Icons.grid_on, color: Colors.white),
                                Text('Template',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          AdmobBannerAd(),
        ],
      ),
    );
  }

  Future<void> cameraButtonOnPressed() async {
    try {
      // Ensure that the camera is initialized
      await _initializeControllerFuture;

      // Construct the path where the image should be saved
      final XFile image = await _controller.takePicture();
      final double cameraAspectRatio = _controller.value.aspectRatio;
      final File modifiedPng = await mediaEnricherService.captureAndSavePng(_previewContainerKey);
      debugPrint(':::>>>>>>>>>>>>>>> debug 01 camera picture ${image.path} ${modifiedPng.path}');
      final File modifiedImage = await mediaEnricherService.mergeImages(File(image.path), modifiedPng.path);
      // Navigate to the DisplayPictureScreen to display the picture
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: modifiedImage.path,
            widgetImagePath: modifiedPng.path,
          ),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error
      print('Error capturing photo: $e');
    }
  }

  void frontCameraToggleOnPressed() {
    frontCameraToggle = !frontCameraToggle;

    var selectedCamera;
    if (frontCameraToggle) {
      for (CameraDescription camera in widget.cameras) {
        if (CameraLensDirection.front == camera.lensDirection) {
          selectedCamera = camera;
        }
      }
    } else {
      selectedCamera = widget.cameras.first;
    }

    _controller = CameraController(
      selectedCamera, // The camera to use
      resolutionPreset, // Resolution preset
      enableAudio: false, // Disable audio recording
    );
    initializeCamera(controller: _controller);
    setState(() {});
  }

  Color getIconButtonColor(bool isActive) {
    return isActive ? Colors.blue : Colors.white;
  }
}
