import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color? _customColor;
  Brightness? _customBrightness;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme {
    if (_themeMode == ThemeMode.light && _customColor != null) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _customColor!),
        scaffoldBackgroundColor: Colors.grey[100],
        brightness: Brightness.light,
        textTheme: GoogleFonts.quicksandTextTheme(),
      );
    }
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      textTheme: GoogleFonts.quicksandTextTheme(),
    );
  }

  ThemeData get darkTheme {
    if (_themeMode == ThemeMode.dark && _customColor != null) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _customColor!,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
        textTheme: GoogleFonts.quicksandTextTheme(ThemeData.dark().textTheme),
      );
    }
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.grey[900],
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurpleAccent,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.quicksandTextTheme(ThemeData.dark().textTheme),
    );
  }

  void toggleTheme(ThemeMode mode,
      {Color? seedColor, Brightness? brightness}) async {
    _themeMode = mode;
    _customColor = seedColor;
    _customBrightness = brightness;
    notifyListeners();
    await _saveThemeToPrefs();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode.name);
    if (_customColor != null && _customBrightness != null) {
      await prefs.setInt('custom_color', _customColor!.value);
      await prefs.setString('custom_brightness', _customBrightness!.name);
    } else {
      await prefs.remove('custom_color');
      await prefs.remove('custom_brightness');
    }
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString('theme_mode');
    final colorInt = prefs.getInt('custom_color');
    final brightnessStr = prefs.getString('custom_brightness');

    if (modeStr != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (m) => m.name == modeStr,
        orElse: () => ThemeMode.system,
      );
    }

    if (colorInt != null && brightnessStr != null) {
      _customColor = Color(colorInt);
      _customBrightness =
          brightnessStr == 'dark' ? Brightness.dark : Brightness.light;
    }

    notifyListeners();
  }
}
