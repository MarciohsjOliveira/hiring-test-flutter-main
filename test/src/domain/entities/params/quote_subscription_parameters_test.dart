import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/params/params.dart';

void main() {
  group('SubscribeQuoteParams', () {
    test('deve instanciar corretamente com valores válidos', () {
      const fakeWebSocket = 'websocket-mock'; // Pode ser qualquer tipo dinâmico
      const instrumentId = 123;

      final params = QuoteSubscriptionParameters(
        socketConnection: fakeWebSocket,
        instrumentIdentifier: instrumentId,
      );

      expect(params.socketConnection, fakeWebSocket);
      expect(params.instrumentIdentifier, instrumentId);
    });

    test('deve aceitar qualquer tipo como webSocket', () {
      final mockWebSocket = {'connection': 'active'};
      const instrumentId = 999;

      final params = QuoteSubscriptionParameters(
        socketConnection: mockWebSocket,
        instrumentIdentifier: instrumentId,
      );

      expect(params.socketConnection, isA<Map>());
      expect(params.instrumentIdentifier, 999);
    });
  });
}
