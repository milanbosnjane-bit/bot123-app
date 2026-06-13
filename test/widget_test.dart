import 'package:aplikacija/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const TradingBotApp());
    expect(find.text('AI TRADING BOT'), findsOneWidget);
  });
}

