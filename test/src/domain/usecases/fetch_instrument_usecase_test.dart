import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

import 'package:mocktail/mocktail.dart';

class MockInstrumentRepository extends Mock implements IInstrumentRepository {}

class MockFoxbitWebSocket extends Mock implements FoxbitWebSocket {}

class FakeFoxbitWebSocket extends Fake implements FoxbitWebSocket {}

void main() {
  late FetchInstrumentsUseCase useCase;
  late MockInstrumentRepository mockRepository;
  late MockFoxbitWebSocket mockWebSocket;

  setUpAll(() {
    // Registra o fallback para FoxbitWebSocket
    registerFallbackValue(FakeFoxbitWebSocket());
  });

  setUp(() {
    mockRepository = MockInstrumentRepository();
    mockWebSocket = MockFoxbitWebSocket();
    useCase = FetchInstrumentsUseCase(mockRepository);
  });

  const instruments = <TradingInstrumentEntity>[
    TradingInstrumentEntity(
      instrumentId: 1,
      ticker: 'BTCUSD',
      primaryProductSymbol: 'BTC',
      secondaryProductSymbol: 'USD',
      indexOrder: 1,
    ),
    TradingInstrumentEntity(
      instrumentId: 2,
      ticker: 'ETHUSD',
      primaryProductSymbol: 'ETH',
      secondaryProductSymbol: 'USD',
      indexOrder: 2,
    ),
  ];

  test('Deve emitir lista de instrumentos quando o repositório retorna sucesso',
      () async {
    when(() => mockRepository.getInstruments(mockWebSocket))
        .thenAnswer((_) async => const Right(instruments));

    final stream = await useCase.buildUseCaseStream(mockWebSocket);

    expect(
      stream,
      emitsInOrder([instruments]),
    );

    verify(() => mockRepository.getInstruments(mockWebSocket)).called(1);
  });

  test('Deve emitir erro quando o repositório retorna falha', () async {
    final failure = ServerFailure();
    when(() => mockRepository.getInstruments(mockWebSocket))
        .thenAnswer((_) async => Left(failure));

    final stream = await useCase.buildUseCaseStream(mockWebSocket);

    expect(
      stream,
      emitsError(failure),
    );

    verify(() => mockRepository.getInstruments(mockWebSocket)).called(1);
  });
}
