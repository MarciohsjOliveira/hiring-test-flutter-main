import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

void main() {
  group('TradingInstrumentModel', () {
    test('deve instanciar corretamente com os parâmetros fornecidos', () {
      // Arrange
      final model = TradingInstrumentModel(
        instrumentId: 1001,
        ticker: 'BTC/BRL',
        primaryProductSymbol: 'BTC',
        secondaryProductSymbol: 'BRL',
        indexOrder: 1,
      );

      // Assert
      expect(model.instrumentId, 1001);
      expect(model.ticker, 'BTC/BRL');
      expect(model.primaryProductSymbol, 'BTC');
      expect(model.secondaryProductSymbol, 'BRL');
      expect(model.indexOrder, 1);
    });

    test('fromJson deve converter um Map em uma instância de TradingInstrumentModel', () {
      // Arrange
      final json = {
        'InstrumentId': 2002,
        'Symbol': 'ETH/BRL',
        'Product1Symbol': 'ETH',
        'Product2Symbol': 'BRL',
        'SortIndex': 2,
      };

      // Act
      final model = TradingInstrumentModel.fromJson(json);

      // Assert
      expect(model.instrumentId, 2002);
      expect(model.ticker, 'ETH/BRL');
      expect(model.primaryProductSymbol, 'ETH');
      expect(model.secondaryProductSymbol, 'BRL');
      expect(model.indexOrder, 2);
    });

    test('deve ser compatível com TradingInstrumentEntity', () {
      // Arrange
      final model = TradingInstrumentModel(
        instrumentId: 3003,
        ticker: 'LTC/BRL',
        primaryProductSymbol: 'LTC',
        secondaryProductSymbol: 'BRL',
        indexOrder: 3,
      );

      // Assert
      expect(model, isA<TradingInstrumentEntity>());
    });
  });
}
