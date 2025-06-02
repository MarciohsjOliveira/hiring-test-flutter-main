import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/data/repositories/heartbeat_repository.dart';
import 'package:foxbit_hiring_test_template/src/domain/usecases/heartbeat_usecase.dart';

import 'core/networking/foxbit_web_socket_test.dart.dart';
import 'default_test_observer.dart';

void main() {
  late TestFoxbitWebSocket webSocket;
  late HeartbeatUseCase useCase;
  late DefaultTestObserver observer;

  setUp(() {
    webSocket = TestFoxbitWebSocket();
    useCase = HeartbeatUseCase(HeartbeatRepository());
    observer = DefaultTestObserver();
  });

  tearDown(() {
    useCase.dispose();
  });

  test('Validate correct execution', () async {
    useCase.execute(observer, webSocket);
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }

    expect(observer.done, true);
    expect(observer.error, false);
  });

  test('Validate websocket ping message formation', () async {
    useCase.execute(observer, webSocket);
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }

    expect(observer.done, true);
    expect(observer.error, false);
    expect(webSocket.sendedMessages.last, '{"m":0,"i":0,"n":"PING","o":"{}"}');
  });
}
