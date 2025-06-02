import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/view/widgets/crypto_list_widget.dart';

void main() {
  TradingInstrumentEntity buildMockInstrument() {
    return const TradingInstrumentEntity(
      instrumentId: 1,
      ticker: 'BTC/BRL',
      primaryProductSymbol: 'BTC',
      secondaryProductSymbol: 'BRL',
      indexOrder: 5,
    );
  }

  MarketQuoteEntity buildMockQuote({
    required String price,
    required double variation,
  }) {
    return MarketQuoteEntity(
      instrumentId: 1,
      latestPrice: price,
      volume24hRolling: 100000.0,
      priceChange24hRolling: variation,
    );
  }

  testWidgets(
      'CryptoListItemWidegt exibe corretamente os dados de uma cripto com variação positiva',
      (WidgetTester tester) async {
    final mockCrypto = CryptoAssetEntity(
      instrumentDetails: buildMockInstrument(),
      latestQuote: buildMockQuote(price: '12345.67', variation: 2.5),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CryptoListItemWidegt(crypto: mockCrypto),
        ),
      ),
    );

    // Verifica se nome do ativo está sendo exibido duas vezes
    expect(find.text('BTC'), findsNWidgets(2));

    // Verifica se o ícone 'add' (indicando alta) está presente
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verifica o valor da variação formatado corretamente
    expect(find.text('2.50'), findsOneWidget);

    // Verifica se o preço formatado está presente
    expect(find.textContaining('R\$'), findsOneWidget);

    // Verifica se o widget da imagem está presente
    expect(find.byType(CryptoImageWidget), findsOneWidget);

    // Verifica os outros widgets internos
    expect(find.byType(CryptoDetailsWidget), findsOneWidget);
    expect(find.byType(CryptoPriceInfo), findsOneWidget);
  });

  testWidgets(
      'CryptoListItemWidegt exibe corretamente a variação negativa com ícone de baixa',
      (WidgetTester tester) async {
    final mockCrypto = CryptoAssetEntity(
      instrumentDetails: buildMockInstrument(),
      latestQuote: buildMockQuote(price: '9876.54', variation: -3.21),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CryptoListItemWidegt(crypto: mockCrypto),
        ),
      ),
    );

    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.text('3.21'), findsOneWidget); // valor absoluto
    expect(find.textContaining('R\$'), findsOneWidget); // preço
  });
}
