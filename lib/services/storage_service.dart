import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> getSharedPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();

    return _prefs!;
  }

  Future<void> setString(String key, String value) async {
    final prefs = await getSharedPrefs();

    prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await getSharedPrefs();

    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final prefs = await getSharedPrefs();

    prefs.remove(key);
  }
}
