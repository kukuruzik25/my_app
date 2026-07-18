import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/countdown_screen.dart';
import 'screens/settings_screen.dart';
import 'models/app_theme.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StorageService _storage = StorageService();
  AppThemeColor _theme = AppThemeColor.pink;
  DisplayFormat _format = DisplayFormat.days;
  bool _loaded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final theme = await _storage.loadTheme();
    final format = await _storage.loadFormat();
    setState(() {
      _theme = theme;
      _format = format;
      _loaded = true;
    });
  }

  void _onThemeChanged(AppThemeColor theme) {
    setState(() => _theme = theme);
    _storage.saveTheme(theme);
  }

  void _onFormatChanged(DisplayFormat format) {
    setState(() => _format = format);
    _storage.saveFormat(format);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const CupertinoApp(home: Center(child: CupertinoActivityIndicator()));
    }

    final colors = ThemeColors.from(_theme);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.inter(fontSize: 17, color: CupertinoColors.black),
        ),
      ),
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                CountdownScreen(theme: _theme, format: _format),
                SettingsScreen(
                  currentTheme: _theme,
                  currentFormat: _format,
                  onThemeChanged: _onThemeChanged,
                  onFormatChanged: _onFormatChanged,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _FloatingTabBar(
                currentIndex: _currentIndex,
                accentColor: colors.primary,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingTabBar extends StatelessWidget {
  final int currentIndex;
  final Color accentColor;
  final ValueChanged<int> onTap;

  const _FloatingTabBar({
    required this.currentIndex,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 28),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              icon: CupertinoIcons.clock,
              label: 'Отсчёт',
              isSelected: currentIndex == 0,
              accentColor: accentColor,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _TabButton(
              icon: CupertinoIcons.settings,
              label: 'Настройки',
              isSelected: currentIndex == 1,
              accentColor: accentColor,
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? accentColor : CupertinoColors.systemGrey;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
