import 'dart:ui';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';


/// Presenter responsável por gerenciar as interações entre
/// a UI e os casos de uso relacionados à home (cotação).
///
/// Controla a execução dos use cases de heartbeat,
/// obtenção de instrumentos e inscrição em cotações,
/// além de comunicar os resultados para a camada de apresentação via callbacks.
class HomePresenter extends Presenter {
  /// Callback chamado quando o heartbeat completa com sucesso.
  late VoidCallback heartbeatOnComplete;

  /// Callback chamado em caso de erro durante o heartbeat.
  late Function(dynamic) heartbeatOnError;

  /// Callback chamado quando os instrumentos são obtidos com sucesso.
  late Function(List<CryptoAssetEntity>) getInstrumentsOnNext;

  /// Callback chamado em caso de erro ao obter instrumentos.
  late Function(dynamic) getInstrumentsOnError;

  /// Callback chamado ao receber uma nova cotação para um instrumento.
  late Function(int instrumentId, MarketQuoteEntity quote) quoteOnNext;

  /// Callback chamado em caso de erro durante a inscrição na cotação.
  late Function(int instrumentId, dynamic error) quoteOnError;

  // Instâncias dos casos de uso.
  final HeartbeatUseCase _heartbeatUseCase =
      HeartbeatUseCase(HeartbeatRepository());
  final FetchInstrumentsUseCase _getInstrumentsUseCase =
      FetchInstrumentsUseCase(InstrumentRepository());
  final SubscribeQuoteUseCase _subscribeQuoteUseCase =
      SubscribeQuoteUseCase(QuoteRepository());

  /// Envia heartbeat via WebSocket.
  void sendHeartbeat(FoxbitWebSocket ws) {
    _heartbeatUseCase.execute(_HeartBeatObserver(this), ws);
  }

  /// Solicita a lista de instrumentos via WebSocket.
  void getInstruments(FoxbitWebSocket ws) {
    _getInstrumentsUseCase.execute(_GetInstrumentsObserver(this), ws);
  }

  /// Inscreve para receber cotações de um instrumento específico.
  ///
  /// [instrumentId] é o identificador do instrumento a ser inscrito.
  void subscribeToQuote(FoxbitWebSocket ws, int instrumentId) {
    final params = QuoteSubscriptionParameters(
      socketConnection: ws,
      instrumentIdentifier: instrumentId,
    );

    _subscribeQuoteUseCase.execute(
      _SubscribeQuoteObserver(this, instrumentId),
      params,
    );
  }

  @override
  void dispose() {
    _heartbeatUseCase.dispose();
    _getInstrumentsUseCase.dispose();
    _subscribeQuoteUseCase.dispose();
  }
}

/// Observer para o caso de uso de heartbeat.
///
/// Repasse eventos para o [HomePresenter].
class _HeartBeatObserver implements Observer<void> {
  final HomePresenter _presenter;

  _HeartBeatObserver(this._presenter);

  @override
  void onNext(_) {}

  @override
  void onComplete() {
    _presenter.heartbeatOnComplete();
  }

  @override
  void onError(dynamic e) {
    _presenter.heartbeatOnError(e);
  }
}

/// Observer para o caso de uso de obtenção de instrumentos.
///
/// Converte [TradingInstrumentEntity] para [CryptoAssetEntity]
/// antes de enviar via callback.
class _GetInstrumentsObserver
    implements Observer<List<TradingInstrumentEntity>> {
  final HomePresenter _presenter;

  _GetInstrumentsObserver(this._presenter);

  @override
  void onNext(List<TradingInstrumentEntity>? instruments) {
    final cryptos = instruments!
        .map((instrument) => CryptoAssetEntity(instrumentDetails: instrument))
        .toList();

    _presenter.getInstrumentsOnNext(cryptos);
  }

  @override
  void onComplete() {}

  @override
  void onError(dynamic e) {
    _presenter.getInstrumentsOnError(e);
  }
}

/// Observer para o caso de uso de inscrição em cotações.
///
/// Recebe cotações e repassa para o [HomePresenter] junto com o ID do instrumento.
class _SubscribeQuoteObserver implements Observer<MarketQuoteEntity> {
  final HomePresenter _presenter;
  final int _instrumentId;

  _SubscribeQuoteObserver(
    this._presenter,
    this._instrumentId,
  );

@override
void onNext(MarketQuoteEntity? quote) {
  if (quote != null) {
    _presenter.quoteOnNext(_instrumentId, quote);
  }
}

  @override
  void onComplete() {}

  @override
  void onError(dynamic e) {
    _presenter.quoteOnError(_instrumentId, e);
  }
}
