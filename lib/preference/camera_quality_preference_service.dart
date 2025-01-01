import 'package:shared_preferences/shared_preferences.dart';

class CameraQualityPreferenceService {
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const int _defaultCameraQualityKey = 3;
  static const String _cameraQualityKey = 'cameraQualityKey';

  static late final SharedPreferences _prefs;

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
}
