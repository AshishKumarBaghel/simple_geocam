import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../advertisement/admob_banner_ad.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _controller = CameraController(
      widget.cameras.first, // The camera to use
      ResolutionPreset.max, // Resolution preset
      enableAudio: false, // Disable audio recording
    );

    // Initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings, color: Colors.white, size: 30),
                      Icon(Icons.flash_on, color: Colors.white, size: 30),
                      Icon(Icons.location_off, color: Colors.white, size: 30),
                      Icon(Icons.circle_outlined, color: Colors.white, size: 30),
                    ],
                  ),
                ),
            
                // Bottom Section
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Location Information Box
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ujjain, Madhya Pradesh, India',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Mahananda Nagar, Ujjain - 456010, Madhya Pradesh, India',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Lat 23.1500 Long 75.802633',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '24/12/2024 8:30 AM GMT+5:30',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
            
                      SizedBox(height: 10),
            
                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            children: [
                              Icon(Icons.photo_library, color: Colors.white, size: 40),
                              Text('Collection', style: TextStyle(color: Colors.white))
                            ],
                          ),
                          const Column(
                            children: [
                              Icon(Icons.map, color: Colors.white, size: 40),
                              Text('Map Data', style: TextStyle(color: Colors.white))
                            ],
                          ),
                          FloatingActionButton(
                            backgroundColor: Colors.yellow,
                            child: Icon(Icons.camera_alt, color: Colors.black),
                            onPressed: () async {
                              try {
                                // Ensure that the camera is initialized
                                await _initializeControllerFuture;
            
                                // Construct the path where the image should be saved
                                final image = await _controller.takePicture();
            
                                // Navigate to the DisplayPictureScreen to display the picture
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DisplayPictureScreen(imagePath: image.path),
                                  ),
                                );
                              } catch (e) {
                                // If an error occurs, log the error
                                print('Error capturing photo: $e');
                              }
                            },
                          ),
                          const Column(
                            children: [
                              Icon(Icons.file_present, color: Colors.white, size: 40),
                              Text('File Name', style: TextStyle(color: Colors.white))
                            ],
                          ),
                          const Column(
                            children: [
                              Icon(Icons.grid_on, color: Colors.white, size: 40),
                              Text('Template', style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          AdmobBannerAd(),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}
