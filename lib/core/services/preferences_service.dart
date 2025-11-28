import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String _viewModeKey = 'view_mode';
  static const String _themeModeKey = 'theme_mode';

  Future<void> setViewMode(String mode) async {
    await _prefs.setString(_viewModeKey, mode);
  }

  String getViewMode() {
    return _prefs.getString(_viewModeKey) ?? 'grid';
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }
}
