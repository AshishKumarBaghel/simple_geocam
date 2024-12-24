import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      ResolutionPreset.high, // Resolution preset
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
      // You need to wait until the controller is initialized before displaying the camera preview
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the controller is initialized, display the camera preview
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        // Capture a photo when the button is pressed
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
    );
  }
}
