import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeProvider() {
    _loadThemeFromStorage();
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    _saveThemeToStorage();
    notifyListeners();
  }
  
  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _saveThemeToStorage();
    notifyListeners();
  }
  
  Future<void> _loadThemeFromStorage() async {
    try {
      final themeString = await _storage.read(key: _themeKey);
      if (themeString != null) {
        _themeMode = themeString == 'dark' 
            ? ThemeMode.dark 
            : ThemeMode.light;
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently, use default theme
    }
  }
  
  Future<void> _saveThemeToStorage() async {
    try {
      final themeString = _themeMode == ThemeMode.dark ? 'dark' : 'light';
      await _storage.write(key: _themeKey, value: themeString);
    } catch (e) {
      // Handle error silently
    }
  }
}