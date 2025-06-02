import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

import 'package:mocktail/mocktail.dart';

class MockFoxbitWebSocket extends Mock implements FoxbitWebSocket {}

void main() {
  late InstrumentRepository repository;
  late MockFoxbitWebSocket mockSocket;

  setUp(() {
    repository = InstrumentRepository();
    mockSocket = MockFoxbitWebSocket();
  });

  test('deve retornar lista de instrumentos ao receber resposta válida', () async {
    final instrumentJson = {
      "InstrumentId": 1,
      "Symbol": "BTC/BRL",
      "Product1Symbol": "BTC",
      "Product2Symbol": "BRL",
      "SortIndex": 0,
    };

    final streamController = StreamController<Map<String, dynamic>>();
    when(() => mockSocket.stream).thenAnswer((_) => streamController.stream);
    when(() => mockSocket.lastId).thenReturn(123);
    when(() => mockSocket.send(any(), any())).thenAnswer((_) async {
      // Simula envio e em seguida adiciona resposta
      Future.delayed(Duration.zero, () {
        streamController.add({
          'n': 'getInstruments',
          'i': 123,
          'o': jsonEncode([instrumentJson]),
        });
      });
    });

    final result = await repository.getInstruments(mockSocket);

    expect(result.isRight(), true);
    expect(result.getOrElse(() => []), isA<List<TradingInstrumentEntity>>());
    expect(result.getOrElse(() => []).first.instrumentId, 1);
  });

  test('deve retornar ServerFailure se "o" for null', () async {
    final streamController = StreamController<Map<String, dynamic>>();
    when(() => mockSocket.stream).thenAnswer((_) => streamController.stream);
    when(() => mockSocket.lastId).thenReturn(999);
    when(() => mockSocket.send(any(), any())).thenAnswer((_) async {
      Future.delayed(Duration.zero, () {
        streamController.add({'n': 'getInstruments', 'i': 999, 'o': null});
      });
    });

    final result = await repository.getInstruments(mockSocket);

    expect(result, Left(ServerFailure()));
  });

  test('deve retornar WebSocketFailure em exceções', () async {
    when(() => mockSocket.send(any(), any())).thenThrow(Exception());

    final result = await repository.getInstruments(mockSocket);

    expect(result, Left(WebSocketFailure()));
  });
}
