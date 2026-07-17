import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme.dart';

enum DisplayFormat { days, hours, weeksAndDays }

class StorageService {
  static const _themeKey = 'theme_color';
  static const _formatKey = 'display_format';

  Future<AppThemeColor> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_themeKey) ?? 'pink';
    return AppThemeColor.values.firstWhere((e) => e.name == name);
  }

  Future<void> saveTheme(AppThemeColor theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.name);
  }

  Future<DisplayFormat> loadFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_formatKey) ?? 'days';
    return DisplayFormat.values.firstWhere((e) => e.name == name);
  }

  Future<void> saveFormat(DisplayFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_formatKey, format.name);
  }
}