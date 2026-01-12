import 'package:shared_preferences/shared_preferences.dart';

enum CacheManager {
  user;

  Future<bool> write(String data) async {
    return SharedPrefManager().write(name, data);
  }

  String read() {
    return SharedPrefManager().read(name);
  }

  Future<bool> remove() => SharedPrefManager().instance.remove(name);
}

class SharedPrefManager {
  static final SharedPrefManager _instance = SharedPrefManager._internal();

  SharedPreferences? _prefs;
  SharedPrefManager._internal();
  factory SharedPrefManager() => _instance;
  SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
          "SharedPreferences non initialisé. Appelle 'init()' avant d'utiliser cette instance.");
    }
    return _prefs!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> write(String name, String data) async {
    return instance.setString(name, data);
  }

  String read(String name) {
    return instance.getString(name) ?? '';
  }
}
