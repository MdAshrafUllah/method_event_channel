import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:method_event_channel/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Full app test', () {
    testWidgets("Timer App Start to End", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text("Get name from Native"));
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining("Name: Ashraf from Android"), findsOneWidget);

      await tester.tap(find.text("Start Timer"));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text("Counter: 3"), findsOneWidget);

      await tester.tap(find.text("Stop Timer"));
      await tester.pump();

      expect(find.text("Status: Stopped"), findsOneWidget);

      print("Integration Test Passed");
    });
  });
}
