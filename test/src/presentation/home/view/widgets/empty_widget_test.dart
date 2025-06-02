import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

void main() {
  testWidgets('EmptyWidget exibe a mensagem correta centralizada', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyWidget(),
        ),
      ),
    );

    // Assert: Verifica se o texto está presente
    expect(find.text('Não há moedas disponíveis no momento.'), findsOneWidget);

    // Verifica se o texto está dentro de um Center
    final centerFinder = find.byType(Center);
    final textFinder = find.descendant(
      of: centerFinder,
      matching: find.text('Não há moedas disponíveis no momento.'),
    );

    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}
