import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/crypto_asset_entity.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/market_quote_entity.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/trading_instrument_entity.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

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

  MarketQuoteEntity buildMockQuote() {
    return const MarketQuoteEntity(
      instrumentId: 1,
      latestPrice: '12345.67',
      volume24hRolling: 1000.0,
      priceChange24hRolling: 5.5,
     
    );
  }

  testWidgets('CryptoDetailsWidget exibe o mainProductName duas vezes com estilos distintos',
      (WidgetTester tester) async {
    // Arrange
    final crypto = CryptoAssetEntity(
      instrumentDetails: buildMockInstrument(),
      latestQuote: buildMockQuote(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CryptoDetailsWidget(crypto: crypto),
        ),
      ),
    );

    // Act & Assert
    final texts = find.text('BTC');
    expect(texts, findsNWidgets(2));

    // Opcional: checar estilos se necessário
    final textWidgets = tester.widgetList<Text>(texts).toList();

    expect(textWidgets[0].style?.fontWeight, FontWeight.bold);
    expect(textWidgets[0].style?.fontSize, AppFontSize.sm);

    expect(textWidgets[1].style?.color, Colors.grey);
    expect(textWidgets[1].style?.fontSize, AppFontSize.xs);
  });
}
