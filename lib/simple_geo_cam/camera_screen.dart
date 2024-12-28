import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_geocam/constant/camera_default.dart';
import 'package:simple_geocam/constant/ui_theme.dart';
import 'package:simple_geocam/service/media_enricher_service.dart';
import 'package:simple_geocam/service/media_repository.dart';
import 'package:simple_geocam/simple_geo_cam/photo_thumbnails_screen.dart';
import 'package:simple_geocam/transport/geo_cam_transport.dart';
import 'package:simple_geocam/ui_widget/geo_location_detail.dart';

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
  final GeoService geoService = GeoService();
  final MediaEnricherService mediaEnricherService = MediaEnricherService();
  final MediaRepository mediaRepository = MediaRepository();
  final ResolutionPreset resolutionPreset = ResolutionPreset.high;
  final GlobalKey _geoCamContainerKey = GlobalKey();
  final UITheme uiTheme = UITheme();
  bool frontCameraToggle = false;

  // Flash Mode Options
  final List<FlashMode> _flashModes = [
    FlashMode.off,
    FlashMode.auto,
    FlashMode.always,
  ];
  int _flashModeIndex = CameraDefault().flashModeIndexDefault; // Track the current flash mode index

  final List<bool> mediaTypeSelection = [
    true, //index 0 camera
    false, //index 1 video
  ];
  bool isCameraSelected = true;

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _controller = CameraController(
      widget.cameras.first, // The camera to use
      resolutionPreset, // Resolution preset
      enableAudio: true, // Disable audio recording
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AdmobBannerAd(),
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
                    top: 5,
                    width: parentWidth,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton<int>(
                            icon: const Icon(Icons.settings_outlined),
                            iconColor: uiTheme.iconColor,
                            itemBuilder: (context) => [
                              // PopupMenuItem 1 Color
                              PopupMenuItem(
                                value: 1,
                                // row with 2 children
                                child: Row(
                                  children: [
                                    Icon(Icons.color_lens_outlined, color: uiTheme.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Color", style: TextStyle(color: uiTheme.textColor))
                                  ],
                                ),
                              ),
                              // PopupMenuItem 2 Position
                              PopupMenuItem(
                                value: 2,
                                // row with two children
                                child: Row(
                                  children: [
                                    Icon(Icons.switch_access_shortcut_outlined, color: uiTheme.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Position", style: TextStyle(color: uiTheme.textColor))
                                  ],
                                ),
                              ),
                              // PopupMenuItem 3 Grid
                              PopupMenuItem(
                                value: 3,
                                // row with 2 children
                                child: Row(
                                  children: [
                                    Icon(Icons.grid_3x3_outlined, color: uiTheme.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Grid", style: TextStyle(color: uiTheme.textColor))
                                  ],
                                ),
                              ),
                              // PopupMenuItem 4 Timer
                              PopupMenuItem(
                                value: 4,
                                // row with 2 children
                                child: Row(
                                  children: [
                                    Icon(Icons.timer_outlined, color: uiTheme.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Timer", style: TextStyle(color: uiTheme.textColor))
                                  ],
                                ),
                              ),
                              // PopupMenuItem 5 Ratio
                              PopupMenuItem(
                                value: 5,
                                // row with 2 children
                                child: Row(
                                  children: [
                                    Icon(Icons.aspect_ratio_outlined, color: uiTheme.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Ratio", style: TextStyle(color: uiTheme.textColor))
                                  ],
                                ),
                              ),
                              // PopupMenuItem 6 Record Video with voice
                              PopupMenuItem(
                                value: 6,
                                // row with two children
                                child: Row(
                                  children: [
                                    Icon(Icons.volume_up_outlined, color: uiTheme.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Record video with voice", style: TextStyle(color: uiTheme.textColor))
                                  ],
                                ),
                              ),
                            ],
                            offset: Offset(0, 55),
                            color: Colors.black.withValues(alpha: 0.5),
                            elevation: 2,
                            // on selected we show the dialog box
                            onSelected: (value) {
                              // if value 1 show dialog
                              if (value == 1) {
                                debugPrint('>>>>>>>>>>1');
                                // if value 2 show dialog
                              } else if (value == 2) {
                                debugPrint('>>>>>>>>>>2');
                              }
                            },
                          ),
                          IconButton(onPressed: _toggleFlashModeOnPressed, icon: _getFlashIcon()),
                          IconButton(
                              onPressed: _frontCameraToggleOnPressed,
                              icon: Icon(Icons.cameraswitch_outlined, color: getIconButtonColor(frontCameraToggle))),
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
                        GeoLocationDetail(geoCamContainerKey: _geoCamContainerKey, geoCamTransport: geoCamTransport),
                        Container(
                          color: Colors.black,
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ToggleButtons(
                                    onPressed: (index) {
                                      setState(() {
                                        for (int i = 0; i < mediaTypeSelection.length; i++) {
                                          mediaTypeSelection[i] = i == index;
                                        }
                                        if (index == 0) {
                                          isCameraSelected = true;
                                        } else {
                                          isCameraSelected = false;
                                        }
                                      });
                                    },
                                    isSelected: mediaTypeSelection,
                                    color: Colors.white,
                                    selectedColor: uiTheme.brandColor,
                                    fillColor: Colors.yellow,
                                    borderRadius: BorderRadius.circular(5),
                                    constraints: const BoxConstraints(
                                      minHeight: 5, // Height of each button (decrease this value)
                                    ),
                                    children: const [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            //color: Colors.white,
                                          ),
                                          Text('Camera ', style: TextStyle(fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.video_camera_back_outlined,
                                            //color: Colors.white,
                                          ),
                                          Text('Video ', style: TextStyle(fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: _collectionOnTapHandler,
                                        child: Column(
                                          children: [
                                            Icon(Icons.photo_library_outlined, color: uiTheme.iconColor),
                                            Text('Collection',
                                                style: TextStyle(
                                                  color: uiTheme.iconColor,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  CameraButton(
                                    size: 64,
                                    onPressed: cameraButtonOnPressed,
                                    color: isCameraSelected ? uiTheme.brandColor : Colors.red,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Column(
                                          children: [
                                            Icon(Icons.grid_view_outlined, color: uiTheme.iconColor),
                                            Text('Template',
                                                style: TextStyle(
                                                  color: uiTheme.textColor,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }

  Future<void> cameraButtonOnPressed() async {
    try {
      // Ensure that the camera is initialized
      await _initializeControllerFuture;

      // Construct the path where the image should be saved
      final XFile image = await _controller.takePicture();
      final Uint8List modifiedPngBytes = await mediaEnricherService.captureAndSavePngBytes(_geoCamContainerKey);
      final Uint8List originalBytes = await image.readAsBytes();
      final Uint8List modifiedFinalImageBytes = await mediaEnricherService.mergeImagesBytes(originalBytes, modifiedPngBytes);
      final tmpFinalPhoto = await mediaRepository.savePhotoBytes(modifiedFinalImageBytes);

      //TODO: temporary added to show clicked picture, in production can be removed!
      // Navigate to the DisplayPictureScreen to display the picture
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: tmpFinalPhoto.path),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error
      print('Error capturing photo: $e');
    }
  }

  void _collectionOnTapHandler() async {
    // Navigate to the Collection to display the picture
    await Navigator.of(context).push(
      MaterialPageRoute(
        //builder: (context) => AlbumScreen(albumPath: albumPath),
        builder: (context) => const PhotoThumbnailsScreen(),
      ),
    );
  }

  void _frontCameraToggleOnPressed() {
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
    return isActive ? uiTheme.iconOnColor : uiTheme.iconColor;
  }

  // ----------------------------------------------------------------
  // FLASH MODE
  // ----------------------------------------------------------------
  Icon _getFlashIcon({double iconSize = 24}) {
    // Return appropriate icon based on the current flash mode
    switch (_flashModes[_flashModeIndex]) {
      case FlashMode.off:
        return Icon(Icons.flash_off_outlined, color: Colors.white, size: iconSize);
      case FlashMode.auto:
        return Icon(Icons.flash_auto_outlined, color: uiTheme.brandColor, size: iconSize);
      case FlashMode.always:
        return Icon(Icons.flash_on_outlined, color: uiTheme.brandColor, size: iconSize);
      default:
        return Icon(Icons.flash_off, color: Colors.white, size: iconSize);
    }
  }

  Future<void> _toggleFlashModeOnPressed() async {
    _flashModeIndex = (_flashModeIndex + 1) % _flashModes.length;
    _changeFlashMode(_flashModes[_flashModeIndex]);
  }

  Future<void> _changeFlashMode(FlashMode flashMode) async {
    await _controller!.setFlashMode(flashMode);
    setState(() {});
  }
}
