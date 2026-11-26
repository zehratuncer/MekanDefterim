import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../../../core/database/app_database.dart';

const _themeModePrefKey = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.dark;
  }

  Future<void> _loadSavedTheme() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final row = await (db.select(db.appPreferencesTable)
            ..where((t) => t.key.equals(_themeModePrefKey)))
          .getSingleOrNull();
      if (row != null) {
        state = _parseThemeMode(row.value);
      }
    } catch (_) {
      // Varsayılan tema ile devam edilir
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final db = ref.read(appDatabaseProvider);
      await db.into(db.appPreferencesTable).insertOnConflictUpdate(
            AppPreferencesTableCompanion.insert(
              key: _themeModePrefKey,
              value: _serializeThemeMode(mode),
            ),
          );
    } catch (_) {
      // UI durumu güncellendi, DB yazılamazsa çökmez
    }
  }

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  static String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

extension ThemeModeLabel on ThemeMode {
  String get labelTr {
    switch (this) {
      case ThemeMode.dark:
        return 'Koyu';
      case ThemeMode.light:
        return 'Açık';
      case ThemeMode.system:
        return 'Sistem';
    }
  }
}
