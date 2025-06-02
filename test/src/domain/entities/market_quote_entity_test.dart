import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';

void main() {
  group('MarketQuoteEntity', () {
    test('deve criar uma instância corretamente com os valores fornecidos', () {
      // Arrange
      const int instrumentId = 123;
      const String latestPrice = '256.90';
      const double volume24hRolling = 32145.0;
      const double priceChange24hRolling = 2.57;

      // Act
      const entity = MarketQuoteEntity(
        instrumentId: instrumentId,
        latestPrice: latestPrice,
        volume24hRolling: volume24hRolling,
        priceChange24hRolling: priceChange24hRolling,
      );

      // Assert
      expect(entity.instrumentId, equals(instrumentId));
      expect(entity.latestPrice, equals(latestPrice));
      expect(entity.volume24hRolling, equals(volume24hRolling));
      expect(entity.priceChange24hRolling, equals(priceChange24hRolling));
    });

    test('duas instâncias com os mesmos valores devem ser iguais', () {
      // Arrange
      const quote1 = MarketQuoteEntity(
        instrumentId: 1,
        latestPrice: '100.0',
        volume24hRolling: 1500.0,
        priceChange24hRolling: 1.2,
      );

      const quote2 = MarketQuoteEntity(
        instrumentId: 1,
        latestPrice: '100.0',
        volume24hRolling: 1500.0,
        priceChange24hRolling: 1.2,
      );

      // Assert
      expect(quote1, equals(quote2));
    });

    test('instâncias diferentes devem ser diferentes', () {
      // Arrange
      const quote1 = MarketQuoteEntity(
        instrumentId: 1,
        latestPrice: '100.0',
        volume24hRolling: 1500.0,
        priceChange24hRolling: 1.2,
      );

      const quote2 = MarketQuoteEntity(
        instrumentId: 2,
        latestPrice: '99.0',
        volume24hRolling: 1800.0,
        priceChange24hRolling: -0.5,
      );

      // Assert
      expect(quote1, isNot(equals(quote2)));
    });
  });
}
