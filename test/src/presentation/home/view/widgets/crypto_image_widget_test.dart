import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

void main() {
  testWidgets('Exibe imagem correta se asset existir', (WidgetTester tester) async {
    // Este teste espera que o asset exista em assets/images/1.png
    const instrumentId = '1';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CryptoImageWidget(instrumentId: instrumentId),
        ),
      ),
    );

    const assetPath = 'assets/images/$instrumentId.png';

    expect(find.byType(Image), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == assetPath,
      ),
      findsOneWidget,
    );
  });

  testWidgets('Exibe ícone de fallback quando imagem não é encontrada', (WidgetTester tester) async {
    const instrumentId = 'not_existing_id';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CryptoImageWidget(instrumentId: instrumentId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.currency_bitcoin), findsOneWidget);
  });
}
