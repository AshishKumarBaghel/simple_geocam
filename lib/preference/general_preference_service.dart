import 'package:shared_preferences/shared_preferences.dart';

class GeneralPreferenceService {
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const int _defaultCameraQualityKey = 3;
  static const String _cameraQualityKey = 'cameraQualityKey';
  static const int _defaultFlashModeIndex = 1;
  static const String _flashModeKey = 'flashModeKey';

  static late final SharedPreferences _prefs;

  // ----------------------------------------------------------------
  // CAMERA QUALITY PERSISTENCE
  // ----------------------------------------------------------------

  void saveCameraQuality({required int cameraQualityKey}) {
    _prefs.setInt(_cameraQualityKey, cameraQualityKey);
  }

  int fetchCameraQuality() {
    int? cameraQualityKey = _prefs.getInt(_cameraQualityKey);
    if (cameraQualityKey == null) {
      return _defaultCameraQualityKey;
    }
    return cameraQualityKey;
  }

  // ----------------------------------------------------------------
  // FLASH MODE PERSISTENCE
  // ----------------------------------------------------------------

  void saveFlashMode({required int flashModeIndex}) {
    _prefs.setInt(_flashModeKey, flashModeIndex);
  }

  int fetchFlashMode() {
    int? flashModeKey = _prefs.getInt(_flashModeKey);
    if (flashModeKey == null) {
      return _defaultFlashModeIndex;
    }
    return flashModeKey;
  }

}
