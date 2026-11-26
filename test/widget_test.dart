import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mekandefterim/app/app.dart';

void main() {
  testWidgets('Mekan Defteri\'m app smoke and onboarding test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MekanDefterimApp(),
      ),
    );

    // Initial render
    await tester.pumpAndSettle();

    // Verify Onboarding elements
    expect(find.text("𝐌𝐞𝐤𝐚𝐧 𝐃𝐞𝐟𝐭𝐞𝐫𝐢'𝐦"), findsOneWidget);
    expect(find.text('Keşfetmeye başla'), findsOneWidget);
  });
}
