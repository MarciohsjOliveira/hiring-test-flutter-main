import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

void main() {
  testWidgets('LoadingWidget exibe CircularProgressIndicator centralizado', (WidgetTester tester) async {
    // Arrange: Renderiza o widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(),
        ),
      ),
    );

    // Assert: Verifica se o CircularProgressIndicator está presente
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verifica se o widget está centralizado (envolvido por um Center)
    final centerFinder = find.byType(Center);
    final circularProgressIndicatorFinder = find.descendant(
      of: centerFinder,
      matching: find.byType(CircularProgressIndicator),
    );

    expect(centerFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });
}
