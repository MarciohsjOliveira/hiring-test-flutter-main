import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';

import 'package:mocktail/mocktail.dart';

class MockFoxbitWebSocket extends Mock implements FoxbitWebSocket {}

void main() {
  group('HeartbeatRepository', () {
    late MockFoxbitWebSocket mockWebSocket;
    late HeartbeatRepository repository;

    setUp(() {
      mockWebSocket = MockFoxbitWebSocket();
      repository = HeartbeatRepository();

      // Necessário registrar o comportamento do método `send`
      when(() => mockWebSocket.send(any(), any())).thenReturn(null);
    });

    test('deve enviar um evento PING e aguardar resposta correspondente', () async {
      // Arrange
      const lastId = 123;
      final expectedMessage = {'n': 'PING', 'i': lastId};

      when(() => mockWebSocket.lastId).thenReturn(lastId);
      when(() => mockWebSocket.stream).thenAnswer(
        (_) => Stream.fromIterable([
          {'n': 'OTHER_EVENT', 'i': 111},
          {'n': 'PING', 'i': lastId}, // Esse deve ser aceito
          {'n': 'PING', 'i': 999},
        ]),
      );

      // Act
      final result = await repository.send(mockWebSocket);

      // Assert
      verify(() => mockWebSocket.send('PING', {})).called(1);
      expect(result, expectedMessage);
    });

    test('deve lançar erro se nenhuma resposta PING válida for encontrada', () async {
      // Arrange
      when(() => mockWebSocket.lastId).thenReturn(555);
      when(() => mockWebSocket.stream).thenAnswer(
        (_) => Stream.fromIterable([
          {'n': 'OTHER', 'i': 123},
          {'n': 'PING', 'i': 999}, // ID incorreto
        ]),
      );

      // Act & Assert
      expect(
        () async => await repository.send(mockWebSocket),
        throwsA(isA<StateError>()), // Porque `firstWhere` não encontra nenhum válido
      );
    });
  });
}
