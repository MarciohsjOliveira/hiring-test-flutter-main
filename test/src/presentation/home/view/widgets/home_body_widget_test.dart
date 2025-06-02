import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/view/widgets/crypto_list_widget.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeController extends Mock implements HomeController {}

void main() {
  late MockHomeController mockController;

  setUp(() {
    mockController = MockHomeController();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(home: widget);
  }

  CryptoAssetEntity buildMockCrypto({
    required String symbol,
    required double variation,
  }) {
    return CryptoAssetEntity(
      instrumentDetails: const TradingInstrumentEntity(
        instrumentId: 1,
        ticker: 'BTC/BRL',
        primaryProductSymbol: 'BTC',
        secondaryProductSymbol: 'BRL',
        indexOrder: 5,
      ),
      latestQuote: MarketQuoteEntity(
        instrumentId: 1,
        latestPrice: '12345.67',
        volume24hRolling: 500000,
        priceChange24hRolling: variation,
      ),
    );
  }

  testWidgets('exibe LoadingWidget quando isLoading é true', (tester) async {
    when(() => mockController.isLoading).thenReturn(true);
    when(() => mockController.errorMessage).thenReturn(null);
    when(() => mockController.cryptos).thenReturn([]);

    await tester
        .pumpWidget(buildTestableWidget(HomeBody(controller: mockController)));

    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('exibe EmptyWidget quando lista está vazia', (tester) async {
    when(() => mockController.isLoading).thenReturn(false);
    when(() => mockController.errorMessage).thenReturn(null);
    when(() => mockController.cryptos).thenReturn([]);

    await tester
        .pumpWidget(buildTestableWidget(HomeBody(controller: mockController)));

    expect(find.byType(EmptyWidget), findsOneWidget);
  });

  testWidgets('exibe lista de CryptoListItemWidegt quando há dados',
      (tester) async {
    final cryptos = [
      buildMockCrypto(symbol: 'BTC/USDT', variation: 3.2),
      buildMockCrypto(symbol: 'ETH/USDT', variation: -1.1),
    ];

    when(() => mockController.isLoading).thenReturn(false);
    when(() => mockController.errorMessage).thenReturn(null);
    when(() => mockController.cryptos).thenReturn(cryptos);
    when(() => mockController.refreshData()).thenAnswer((_) async {});

    await tester
        .pumpWidget(buildTestableWidget(HomeBody(controller: mockController)));

    expect(find.byType(CryptoListItemWidegt), findsNWidgets(2));
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
