// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:walletflow/main.dart';

void main() {
  testWidgets('WalletFlow app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WalletFlowApp());

    // Verify that our app shows the WalletFlow title.
    expect(find.text('WalletFlow ✨'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
