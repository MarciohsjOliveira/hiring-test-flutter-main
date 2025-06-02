import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/view/widgets/crypto_list_widget.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeController extends Mock implements HomeController {}

void main() {
  late MockHomeController mockController;

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

  setUp(() {
    mockController = MockHomeController();
    registerFallbackValue([]);
  });

  testWidgets(
      'HomePage exibe AppBar, HomeBody e dispara refreshData no pull-to-refresh',
      (tester) async {
    // Arrange: configurar o comportamento do controller mockado
    when(() => mockController.isLoading).thenReturn(false);
    when(() => mockController.errorMessage).thenReturn(null);
    when(() => mockController.cryptos).thenReturn([
      buildMockCrypto(symbol: 'BTC/USDT', variation: 1.5),
      buildMockCrypto(symbol: 'ETH/USDT', variation: -2.3),
    ]);
    when(() => mockController.refreshData()).thenAnswer((_) async {});

    // Act: construir a widget HomePage com controller injetado
    await tester.pumpWidget(
      MaterialApp(
        home: HomePageTestable(controller: mockController),
      ),
    );

    // Assert: verificar AppBar
    expect(find.text('Cotação'), findsOneWidget);

    // Assert: HomeBody está na árvore de widgets
    expect(find.byType(HomeBody), findsOneWidget);

    // Assert: quantidade de CryptoListItemWidegt igual ao tamanho da lista mockada
    expect(find.byType(CryptoListItemWidegt), findsNWidgets(2));

    // Simular pull-to-refresh (drag para baixo)
    final refreshIndicator = find.byType(RefreshIndicator);
    expect(refreshIndicator, findsOneWidget);

    await tester.fling(refreshIndicator, const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    // Verificar se o refreshData foi chamado uma vez
    verify(() => mockController.refreshData()).called(1);
  });
}

class HomePageTestable extends StatefulWidget {
  final HomeController controller;

  const HomePageTestable({
    super.key,
    required this.controller,
  });

  @override
  State<HomePageTestable> createState() => _HomePageTestableState();
}

class _HomePageTestableState extends State<HomePageTestable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Cotação",
            style: TextStyle(color: Colors.black),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: HomeBody(controller: widget.controller),
    );
  }
}
