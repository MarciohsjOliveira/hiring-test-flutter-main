import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/crypto_asset_entity.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/market_quote_entity.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/trading_instrument_entity.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';
import 'package:intl/intl.dart';

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

  MarketQuoteEntity buildMockQuote({required String latestPrice}) {
    return MarketQuoteEntity(
      instrumentId: 1,
      latestPrice: latestPrice,
      volume24hRolling: 1000.0,
      priceChange24hRolling: 5.5,

    );
  }

  testWidgets('CryptoPriceInfo exibe preço formatado corretamente', (WidgetTester tester) async {
    // Arrange
    final quote = buildMockQuote(latestPrice: '12345.67');
    final instrument = buildMockInstrument();
    final crypto = CryptoAssetEntity(
      instrumentDetails: instrument,
      latestQuote: quote,
    );

    final expectedFormattedPrice =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(12345.67);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CryptoPriceInfo(crypto: crypto),
        ),
      ),
    );

    // Assert
    expect(find.text(expectedFormattedPrice), findsOneWidget);
  });

  testWidgets('CryptoPriceInfo mostra R\$0,00 quando latestQuote é null', (WidgetTester tester) async {
    // Arrange
    final instrument = buildMockInstrument();
    final crypto = CryptoAssetEntity(
      instrumentDetails: instrument,
     
    );

    final expectedFormattedPrice =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(0.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CryptoPriceInfo(crypto: crypto),
        ),
      ),
    );

    // Assert
    expect(find.text(expectedFormattedPrice), findsOneWidget);
  });

  testWidgets('CryptoPriceInfo mostra R\$0,00 para preço inválido', (WidgetTester tester) async {
    // Arrange
    final quote = buildMockQuote(latestPrice: 'abc'); // inválido
    final instrument = buildMockInstrument();
    final crypto = CryptoAssetEntity(
      instrumentDetails: instrument,
      latestQuote: quote,
    );

    final expectedFormattedPrice =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(0.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CryptoPriceInfo(crypto: crypto),
        ),
      ),
    );

    // Assert
    expect(find.text(expectedFormattedPrice), findsOneWidget);
  });
}
