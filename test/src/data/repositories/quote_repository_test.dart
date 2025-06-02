import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:mocktail/mocktail.dart';

class MockFoxbitWebSocket extends Mock implements FoxbitWebSocket {}

void main() {
  late QuoteRepository repository;
  late MockFoxbitWebSocket mockWebSocket;

  setUp(() {
    mockWebSocket = MockFoxbitWebSocket();
    repository = QuoteRepository();

    // Registrar fallback para Map<String, dynamic> no mocktail
    registerFallbackValue(<String, dynamic>{});
  });

  test(
      'deve retornar sucesso com MarketQuoteEntity quando receber mensagem válida',
      () async {
    const instrumentId = 1;

    final quoteMap = {
      'InstrumentId': instrumentId,
      'LastTradedPx': '123.45',
      'Rolling24HrVolume': 4567.89,
      'Rolling24HrPxChange': -2.34,
    };

    final validMessage = {
      'n': 'SubscribeLevel1',
      'i': 100,
      'o': quoteMap,
    };

    when(() => mockWebSocket.lastId).thenReturn(100);
    when(() => mockWebSocket.stream)
        .thenAnswer((_) => Stream.value(validMessage));
    when(
      () => mockWebSocket.send(
        'SubscribeLevel1',
        {
          'InstrumentId': instrumentId,
        },
      ),
    ).thenReturn(null);

    final result =
        await repository.subscribeToQuote(mockWebSocket, instrumentId);

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Esperado sucesso, mas retornou falha'),
      (quote) => expect(quote.instrumentId, instrumentId),
    );
  });

  test('deve retornar ServerFailure se campo "o" for nulo', () async {
    const instrumentId = 1;

    final invalidMessage = {
      'n': 'SubscribeLevel1',
      'i': 100,
      'o': null,
    };

    when(() => mockWebSocket.lastId).thenReturn(100);
    when(() => mockWebSocket.stream)
        .thenAnswer((_) => Stream.value(invalidMessage));
    when(
      () => mockWebSocket.send(
        'SubscribeLevel1',
        {'InstrumentId': instrumentId},
      ),
    ).thenReturn(null);

    final result =
        await repository.subscribeToQuote(mockWebSocket, instrumentId);

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Esperado ServerFailure, mas retornou sucesso'),
    );
  });

  test('deve retornar ServerFailure se campo "o" for map vazio', () async {
    const instrumentId = 1;

    final emptyMessage = {
      'n': 'SubscribeLevel1',
      'i': 100,
      'o': <String, dynamic>{},
    };

    when(() => mockWebSocket.lastId).thenReturn(100);
    when(() => mockWebSocket.stream)
        .thenAnswer((_) => Stream.value(emptyMessage));
    when(
      () => mockWebSocket.send(
        'SubscribeLevel1',
        {'InstrumentId': instrumentId},
      ),
    ).thenReturn(null);

    final result =
        await repository.subscribeToQuote(mockWebSocket, instrumentId);

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Esperado ServerFailure, mas retornou sucesso'),
    );
  });

  test('deve retornar WebSocketFailure se lançar exceção', () async {
    const instrumentId = 1;

    when(() => mockWebSocket.lastId).thenThrow(Exception('Erro no mock'));
    when(() => mockWebSocket.send(any(), any())).thenReturn(null);

    final result =
        await repository.subscribeToQuote(mockWebSocket, instrumentId);

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<WebSocketFailure>()),
      (_) => fail('Esperado WebSocketFailure, mas retornou sucesso'),
    );
  });

  test('deve emitir valores no stream getQuoteStream', () async {
    const instrumentId = 1;

    final quoteMap = {
      'InstrumentId': instrumentId,
      'LastTradedPx': '123.45',
      'Rolling24HrVolume': 4567.89,
      'Rolling24HrPxChange': -2.34,
    };

    final validMessage = {
      'n': 'SubscribeLevel1',
      'i': 100,
      'o': quoteMap,
    };

    when(() => mockWebSocket.lastId).thenReturn(100);
    when(() => mockWebSocket.stream)
        .thenAnswer((_) => Stream.value(validMessage));
    when(
      () => mockWebSocket.send(
        'SubscribeLevel1',
        {'InstrumentId': instrumentId},
      ),
    ).thenReturn(null);

    await repository.subscribeToQuote(mockWebSocket, instrumentId);

    final streamValue = await repository.getQuoteStream(instrumentId).first;

    expect(streamValue.isRight(), true);
    streamValue.fold(
      (_) => fail('Esperado sucesso no stream'),
      (quote) => expect(quote.instrumentId, instrumentId),
    );
  });
}
