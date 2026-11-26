import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/app/providers.dart';
import 'package:mekandefterim/core/database/app_database.dart';
import 'package:mekandefterim/features/settings/presentation/pages/settings_page.dart';

void main() {
  testWidgets('SettingsPage allows changing theme mode and persists to AppPreferences',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Koyu'), findsOneWidget);

    // Tema satırına dokun
    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    // Açık temayı seç
    await tester.tap(find.text('Açık'));
    await tester.pumpAndSettle();

    expect(find.text('Açık'), findsOneWidget);

    // DB'ye kaydedildiğini doğrula
    final saved = await (db.select(db.appPreferencesTable)
          ..where((t) => t.key.equals('theme_mode')))
        .getSingleOrNull();
    expect(saved?.value, 'light');
  });
}
