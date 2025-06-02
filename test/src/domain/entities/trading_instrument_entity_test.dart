import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';

void main() {
  group('TradingInstrument', () {
    test('deve criar instância com todos os campos corretamente atribuídos',
        () {
      const instrument = TradingInstrumentEntity(
        instrumentId: 1,
        ticker: 'BTC/BRL',
        primaryProductSymbol: 'BTC',
        secondaryProductSymbol: 'BRL',
        indexOrder: 5,
      );

      expect(instrument.instrumentId, 1);
      expect(instrument.ticker, 'BTC/BRL');
      expect(instrument.primaryProductSymbol, 'BTC');
      expect(instrument.secondaryProductSymbol, 'BRL');
      expect(instrument.indexOrder, 5);
    });

    test('deve permitir uso de const para otimização em tempo de compilação',
        () {
      const instrument = TradingInstrumentEntity(
        instrumentId: 42,
        ticker: 'ETH/USDT',
        primaryProductSymbol: 'ETH',
        secondaryProductSymbol: 'USDT',
        indexOrder: 2,
      );

      expect(instrument.ticker, isA<String>());
    });
  });
}
