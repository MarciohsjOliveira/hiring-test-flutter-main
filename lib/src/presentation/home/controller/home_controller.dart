import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/crypto_asset_entity.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/market_quote_entity.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

/// Controller da Home que gerencia a comunicação com o WebSocket da Foxbit
/// e atualiza a interface conforme os dados de criptomoedas e cotações
class HomeController extends Controller {
  final HomePresenter presenter;
  final FoxbitWebSocket ws;

  // Estado da View
  List<CryptoAssetEntity> cryptos = [];
  bool isLoading = true;
  String? errorMessage;

  /// Lista fixa de IDs de instrumentos considerados relevantes
  final List<int> relevantInstrumentIds = [1, 2, 4, 6, 10];

  /// Construtor padrão
  HomeController()
      : presenter = HomePresenter(),
        ws = FoxbitWebSocket() {
    _initialize();
  }

  /// Construtor para teste que permite injeção de presenter e websocket
  @visibleForTesting
  HomeController.test({
    required this.presenter,
    required this.ws,
  });

  /// Inicializa manualmente a controller (útil para testes)
  Future<void> initialize() async {
    await _initialize();
  }

  /// Inicializa a conexão WebSocket e realiza a primeira carga de dados
  Future<void> _initialize() async {
    ws.connect();
    presenter.sendHeartbeat(ws);

    // Aguarda pequena pausa para garantir conexão antes de buscar instrumentos
    await Future.delayed(const Duration(milliseconds: 500));
    presenter.getInstruments(ws);
  }

  /// Permite recarregar os dados manualmente
  void refreshData() {
    isLoading = true;
    errorMessage = null;
    refreshUI();

    presenter.getInstruments(ws);
  }

  /// Inscreve nas cotações dos instrumentos relevantes
  void _subscribeToRelevantQuotes() {
    for (final crypto in cryptos) {
      if (relevantInstrumentIds.contains(crypto.instrumentId)) {
        presenter.subscribeToQuote(ws, crypto.instrumentId);
      }
    }
  }

  @override
  void onDisposed() {
    ws.disconnect();
    presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    // Heartbeat
    presenter.heartbeatOnComplete = _onHeartbeatComplete;
    presenter.heartbeatOnError = _onHeartbeatError;

    // Instrumentos
    presenter.getInstrumentsOnNext = _onGetInstrumentsSuccess;
    presenter.getInstrumentsOnError = _onGetInstrumentsError;

    // Quotes
    presenter.quoteOnNext = _onQuoteUpdate;
    presenter.quoteOnError = _onQuoteError;
  }

  // === Heartbeat callbacks ===

  void _onHeartbeatComplete() => _scheduleNextHeartbeat();

  void _onHeartbeatError(dynamic e) {
    ScaffoldMessenger.of(getContext()).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 10),
        content: Text('Não foi possível enviar a mensagem: [PING]'),
      ),
    );
    _scheduleNextHeartbeat();
  }

  void _scheduleNextHeartbeat() {
    Timer(const Duration(seconds: 30), () {
      presenter.sendHeartbeat(ws);
    });
  }

  // === Instruments callbacks ===

  void _onGetInstrumentsSuccess(List<CryptoAssetEntity> instruments) {
    cryptos = instruments
        .where((crypto) => relevantInstrumentIds.contains(crypto.instrumentId))
        .toList()
      ..sort(
        (a, b) => a.instrumentDetails.indexOrder.compareTo(
          b.instrumentDetails.indexOrder,
        ),
      );

    isLoading = false;
    errorMessage = null;
    refreshUI();

    _subscribeToRelevantQuotes();
  }

  void _onGetInstrumentsError(dynamic e) {
    isLoading = false;
    errorMessage = 'Não foi possível carregar a lista de moedas';
    refreshUI();

    ScaffoldMessenger.of(getContext()).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(errorMessage!),
        action: SnackBarAction(
          label: 'Tentar novamente',
          onPressed: refreshData,
        ),
      ),
    );
  }

  // === Quote callbacks ===

  void _onQuoteUpdate(int instrumentId, MarketQuoteEntity quote) {
    final index =
        cryptos.indexWhere((crypto) => crypto.instrumentId == instrumentId);
    if (index != -1) {
      cryptos[index] = cryptos[index].copyWithNewQuote(quote);
      refreshUI();
    }
  }

  void _onQuoteError(int instrumentId, dynamic e) {
    // Tenta novamente a inscrição após 5 segundos
    Timer(const Duration(seconds: 5), () {
      presenter.subscribeToQuote(ws, instrumentId);
    });
  }
}
