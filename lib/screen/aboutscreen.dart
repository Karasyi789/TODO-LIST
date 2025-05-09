import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color? _seedColor;
  Brightness? _brightness;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  Color? get customSeedColor => _seedColor;
  Brightness? get customBrightness => _brightness;

  ThemeData get currentTheme {
    if (_seedColor != null && _brightness != null) {
      return _brightness == Brightness.dark
          ? customDarkTheme(_seedColor!)
          : customLightTheme(_seedColor!);
    }
    return _themeMode == ThemeMode.dark ? darkTheme : lightTheme;
  }

  void toggleTheme(ThemeMode mode,
      {Color? seedColor, Brightness? brightness}) async {
    _themeMode = mode;
    _seedColor = seedColor;
    _brightness = brightness;
    notifyListeners();
    await _saveThemeToPrefs();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode.name);
    if (_seedColor != null && _brightness != null) {
      await prefs.setInt('custom_color', _seedColor!.value);
      await prefs.setString('custom_brightness', _brightness!.name);
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
      _seedColor = Color(colorInt);
      _brightness =
          brightnessStr == 'dark' ? Brightness.dark : Brightness.light;
    }

    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData.light().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: GoogleFonts.poppinsTextTheme(),
      );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      );

  ThemeData customLightTheme(Color seedColor) {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }

  ThemeData customDarkTheme(Color seedColor) {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[900],
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    );
  }
}
