import 'package:flutter/cupertino.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  final AppThemeColor currentTheme;
  final DisplayFormat currentFormat;
  final void Function(AppThemeColor) onThemeChanged;
  final void Function(DisplayFormat) onFormatChanged;

  const SettingsScreen({
    super.key,
    required this.currentTheme,
    required this.currentFormat,
    required this.onThemeChanged,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Настройки'),
        backgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: Text(
                'ЦВЕТ ТЕМЫ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                  letterSpacing: 0.6,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: AppThemeColor.values.map((theme) {
                      final colors = ThemeColors.from(theme);
                      final isSelected = theme == currentTheme;
                      return GestureDetector(
                        onTap: () => onThemeChanged(theme),
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? const Icon(CupertinoIcons.check_mark,
                                  color: CupertinoColors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CupertinoListSection.insetGrouped(
  header: Text(
    'ФОРМАТ ОТОБРАЖЕНИЯ',
    style: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: CupertinoColors.systemGrey,
      letterSpacing: 0.6,
    ),
  ),
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: CupertinoSlidingSegmentedControl<DisplayFormat>(
        groupValue: currentFormat,
        children: {
          DisplayFormat.days: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text('Дни', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          DisplayFormat.hours: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text('Часы', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          DisplayFormat.weeksAndDays: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text('Недели', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        },
        onValueChanged: (value) {
          if (value != null) onFormatChanged(value);
        },
      ),
    ),
  ],
),
          ],
        ),
      ),
    );
  }
}