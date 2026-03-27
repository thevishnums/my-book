import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyBooksApp());

    // Verify that the login screen title is present.
    expect(find.text('My Book Library'), findsOneWidget);
  });
}
