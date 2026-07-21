import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import '../constants.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';

class CountdownScreen extends StatefulWidget {
  final AppThemeColor theme;
  final DisplayFormat format;

  const CountdownScreen({super.key, required this.theme, required this.format});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;

  @override
   void initState() {
    super.initState();
    // Инициализируем группу, строго как в файлах .entitlements на GitHub
    HomeWidget.setAppGroupId('group.com.example.myCountdownApp');
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  Future<void> _updateWidgetData(String bigNumber, String unitLabel) async {
    // Конвертируем текущий enum темы в HEX для Swift-виджета
    String colorHex;
    switch (widget.theme) {
      case AppThemeColor.pink: colorHex = '#BA0D61'; break;
      case AppThemeColor.blue: colorHex = '#1967D2'; break;
      case AppThemeColor.purple: colorHex = '#6A1B9A'; break;
      case AppThemeColor.green: colorHex = '#2E7D32'; break;
      case AppThemeColor.orange: colorHex = '#EF6C00'; break;
      default: colorHex = '#BA0D61';
    }

     // Сохраняем данные по ключам, которые ждет наш WidgetExtension.swift
    await HomeWidget.saveWidgetData<String>('widget_title', eventTitle);
    await HomeWidget.saveWidgetData<String>('widget_count', bigNumber);
    await HomeWidget.saveWidgetData<String>('widget_format_text', unitLabel);
    await HomeWidget.saveWidgetData<String>('widget_color_hex', colorHex);

   // Вызываем обновление нативного iOS таргет-виджета
  await HomeWidget.updateWidget(
      name: 'WidgetExtension',
      iOSName: 'WidgetExtension',
    );
  }

  String _elapsedLabel(Duration elapsed) {
    switch (widget.format) {
      case DisplayFormat.days:
        return 'Прошло дней: ${elapsed.inDays}';
      case DisplayFormat.hours:
        return 'Прошло часов: ${elapsed.inHours}';
      case DisplayFormat.weeksAndDays:
        final w = elapsed.inDays ~/ 7;
        final d = elapsed.inDays % 7;
        return 'Прошло: $w нед $d дн';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.from(widget.theme);
    final now = DateTime.now();
    final remaining = eventDate.difference(now);
    final elapsed = now.difference(startDate);
    final totalDuration = eventDate.difference(startDate);

    double progress = elapsed.inMinutes / totalDuration.inMinutes;
    progress = progress.clamp(0.0, 1.0);

    final String bigNumber;
    final String unitLabel;
    switch (widget.format) {
      case DisplayFormat.days:
        bigNumber = remaining.inDays.toString();
        unitLabel = 'дней осталось';
        break;
      case DisplayFormat.hours:
        bigNumber = remaining.inHours.toString();
        unitLabel = 'часов осталось';
        break;
      case DisplayFormat.weeksAndDays:
        final weeks = remaining.inDays ~/ 7;
        final days = remaining.inDays % 7;
        bigNumber = '$weeks нед $days дн';
        unitLabel = 'осталось';
        break;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                eventTitle,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: colors.secondary,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  bigNumber,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 96,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                unitLabel,
                style: GoogleFonts.inter(fontSize: 17, color: colors.secondary),
              ),
              const SizedBox(height: 40),
              _ProgressGrid(progress: progress, colors: colors, totalDuration: totalDuration),
              const SizedBox(height: 20),
              Text(
                _elapsedLabel(elapsed),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: colors.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressGrid extends StatelessWidget {
  final double progress;
  final ThemeColors colors;
  final Duration totalDuration;

  const _ProgressGrid({required this.progress, required this.colors, required this.totalDuration});

  @override
  Widget build(BuildContext context) {
    final totalCells = totalDuration.inDays.clamp(1, 60);
    final filledCells = (progress * totalCells).round();
    const columns = 10;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final isFilled = index < filledCells;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: isFilled ? colors.primary : CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
    );
  }
}
