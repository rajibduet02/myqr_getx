import 'package:flutter_test/flutter_test.dart';
import 'package:myqr_getx/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyQrGetxApp());
    expect(find.text('AttoQR'), findsOneWidget);
  });
}
