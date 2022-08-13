import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageProvider {
  String? getString(String key);
  void set(String key, String? value);
}

class PreferenceProvider implements StorageProvider {
  late final SharedPreferences _prefs;
  Future<void> initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  void set(String key, String? value) {
    if (value == null) {
      _prefs.remove(key);
    } else {
      _prefs.setString(key, value);
    }
  }
}
