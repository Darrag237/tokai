import 'package:flutter_test/flutter_test.dart';
import 'package:tokai_app/app.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TokaiApp());
    expect(find.byType(TokaiApp), findsOneWidget);
  });
}
