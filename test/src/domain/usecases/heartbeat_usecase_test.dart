import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

import 'package:mocktail/mocktail.dart';

class MockHeartbeatRepository extends Mock implements IHeartbeatRepository {}

class FakeFoxbitWebSocket extends Fake implements FoxbitWebSocket {}

void main() {
  late HeartbeatUseCase useCase;
  late MockHeartbeatRepository mockRepository;
  late FakeFoxbitWebSocket mockWebSocket;

  setUp(() {
    mockRepository = MockHeartbeatRepository();
    useCase = HeartbeatUseCase(mockRepository);
    mockWebSocket = FakeFoxbitWebSocket();
  });

  test('deve completar com sucesso quando send é chamado com sucesso', () async {
    // Arrange
    when(() => mockRepository.send(mockWebSocket))
        .thenAnswer((_) async => {'success': true});

    // Act
    final resultStream = await useCase.buildUseCaseStream(mockWebSocket);

    // Assert
    expectLater(resultStream, emitsDone); // Stream fecha corretamente
    verify(() => mockRepository.send(mockWebSocket)).called(1);
  });

  test('deve emitir erro quando send lança exceção', () async {
    // Arrange
    final exception = Exception('Falha no envio do heartbeat');
    when(() => mockRepository.send(mockWebSocket))
        .thenThrow(exception);

    // Act
    final resultStream = await useCase.buildUseCaseStream(mockWebSocket);

    // Assert
    expectLater(resultStream, emitsError(isA<Exception>()));
    verify(() => mockRepository.send(mockWebSocket)).called(1);
  });
}
