import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

import 'package:mocktail/mocktail.dart';

class MockQuoteRepository extends Mock implements IQuoteRepository {}

class FakeFoxbitWebSocket extends Fake implements FoxbitWebSocket {}

void main() {
  late SubscribeQuoteUseCase useCase;
  late MockQuoteRepository mockRepository;
  late FakeFoxbitWebSocket fakeWebSocket;
  late QuoteSubscriptionParameters params;

  setUpAll(() {
    registerFallbackValue(FakeFoxbitWebSocket());
  });

  setUp(() {
    mockRepository = MockQuoteRepository();
    useCase = SubscribeQuoteUseCase(mockRepository);
    fakeWebSocket = FakeFoxbitWebSocket();
    params = QuoteSubscriptionParameters(
      socketConnection: fakeWebSocket,
      instrumentIdentifier: 1234,
    );
  });

  test('deve emitir a cotação inicial e atualizações subsequentes', () async {
    // Arrange
    const initialQuote = MarketQuoteEntity(
      instrumentId: 1234,
      latestPrice: '100.0',
      volume24hRolling: 5000.0,
      priceChange24hRolling: 1.5,
    );

    const updatedQuote = MarketQuoteEntity(
      instrumentId: 1234,
      latestPrice: '105.0',
      volume24hRolling: 6000.0,
      priceChange24hRolling: 2.0,
    );

    // Resposta da primeira chamada
    when(() => mockRepository.subscribeToQuote(any(), any()))
        .thenAnswer((_) async => const Right(initialQuote));

    // Stream de atualizações subsequentes
    final streamController =
        StreamController<Either<Failure, MarketQuoteEntity>>();
    when(() => mockRepository.getQuoteStream(any()))
        .thenAnswer((_) => streamController.stream);

    // Act
    final resultStream = await useCase.buildUseCaseStream(params);

    // Assert
    final expectedQuotes = [
      initialQuote,
      updatedQuote,
    ];

    // Adiciona a nova cotação ao stream simulado
    streamController.add(const Right(updatedQuote));
    streamController.close();

    expectLater(resultStream, emitsInOrder(expectedQuotes));
  });

  test('deve emitir erro se uma exceção for lançada', () async {
    // Arrange
    when(() => mockRepository.subscribeToQuote(any(), any()))
        .thenThrow(Exception('Erro inesperado'));

    // Act
    final resultStream = await useCase.buildUseCaseStream(params);

    // Assert
    expectLater(resultStream, emitsError(isA<Exception>()));
  });
}
