import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';

void main() {
  group('CryptoAssetEntity', () {
    const  instrument = TradingInstrumentEntity(
      instrumentId: 123,
      ticker: 'BTC/USDT',
      primaryProductSymbol: 'BTC',
      secondaryProductSymbol: 'USDT',
      indexOrder: 1,
    );

    const  quote = MarketQuoteEntity(
      instrumentId: 123,
      latestPrice: '29500.50',
      volume24hRolling: 150.0,
      priceChange24hRolling: -1.25,
    );

    test('deve criar instância corretamente com dados completos', () {
      final asset = CryptoAssetEntity(
        instrumentDetails: instrument,
        latestQuote: quote,
      );

      expect(asset.instrumentId, 123);
      expect(asset.mainProductName, 'BTC');
      expect(asset.tradingPair, 'USDT');
      expect(asset.currentPrice, '29500.50');
      expect(asset.tradedVolume24h, 150.0);
      expect(asset.priceVariation24h, -1.25);
    });

    test('deve retornar valores default quando latestQuote for null', () {
      final asset = CryptoAssetEntity(
        instrumentDetails: instrument,
      );

      expect(asset.currentPrice, '0.0');
      expect(asset.tradedVolume24h, 0.0);
      expect(asset.priceVariation24h, 0.0);
    });

    test('copyWithNewQuote deve retornar nova instância com nova cotação', () {
      final oldAsset = CryptoAssetEntity(
        instrumentDetails: instrument,
     
      );

      final updatedAsset = oldAsset.copyWithNewQuote(quote);

      expect(updatedAsset.latestQuote, isNotNull);
      expect(updatedAsset.currentPrice, '29500.50');
      expect(updatedAsset.instrumentDetails, oldAsset.instrumentDetails);
    });
  });
}
