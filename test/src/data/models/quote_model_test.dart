import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

void main() {
  group('QuoteModel', () {
    test('deve instanciar corretamente com os parâmetros fornecidos', () {
      // Arrange
      final quote = QuoteModel(
        instrumentId: 123,
        latestPrice: '456.78',
        volume24hRolling: 10000.5,
        priceChange24hRolling: -1.5,
      );

      // Assert
      expect(quote.instrumentId, 123);
      expect(quote.latestPrice, '456.78');
      expect(quote.volume24hRolling, 10000.5);
      expect(quote.priceChange24hRolling, -1.5);
    });

    test('fromJson deve converter um Map em uma instância de QuoteModel', () {
      // Arrange
      final json = {
        'InstrumentId': 999,
        'LastTradedPx': '789.12',
        'Rolling24HrVolume': 5000,
        'Rolling24HrPxChange': 3.25,
      };

      // Act
      final model = QuoteModel.fromJson(json);

      // Assert
      expect(model.instrumentId, 999);
      expect(model.latestPrice, '789.12');
      expect(model.volume24hRolling, 5000.0);
      expect(model.priceChange24hRolling, 3.25);
    });

    test('toJson deve converter a instância em um Map corretamente', () {
      // Arrange
      final model = QuoteModel(
        instrumentId: 1,
        latestPrice: '123.45',
        volume24hRolling: 777.0,
        priceChange24hRolling: -0.7,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['InstrumentId'], 1);
      expect(json['LastTradedPx'], '123.45');
      expect(json['Rolling24HrVolume'], 777.0);
      expect(json['Rolling24HrPxChange'], -0.7);
    });

    test('deve ser compatível com MarketQuoteEntity', () {
      // Arrange
      final model = QuoteModel(
        instrumentId: 101,
        latestPrice: '999.99',
        volume24hRolling: 12345.0,
        priceChange24hRolling: 0.55,
      );

      // Assert
      expect(model, isA<MarketQuoteEntity>());
      expect(model.instrumentId, 101);
    });
  });
}
