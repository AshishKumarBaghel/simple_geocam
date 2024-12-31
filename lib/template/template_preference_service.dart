import 'package:shared_preferences/shared_preferences.dart';

class TemplatePreferenceService {
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _defaultTemplateKey = 'advance';
  static const String _templateKey = 'templateKey';

  static late final SharedPreferences _prefs;

  // names
  void saveTemplate({required String templateKey}) {
    _prefs.setString(_templateKey, templateKey.toLowerCase());
  }

  String fetchTemplate() {
    var templateKey = _prefs.getString(_templateKey);
    if (templateKey == null) {
      return _defaultTemplateKey;
    }
    return templateKey.toLowerCase();
  }
}
