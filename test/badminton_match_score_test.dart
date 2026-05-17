import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoring_app/features/scoring/presentation/pages/badminton_match_score.dart';

void main() {
  testWidgets('badminton score screen increments scores and reveals end set', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BadmintonMatchScoreScreen(matchId: 'match-1'),
      ),
    );

    expect(find.text('0'), findsWidgets);

    for (var i = 0; i < 21; i++) {
      await tester.tap(find.widgetWithText(ElevatedButton, '+1 Point').first);
      await tester.pump();
    }

    expect(find.text('21'), findsOneWidget);

    expect(find.text('End Set'), findsOneWidget);
  });
}