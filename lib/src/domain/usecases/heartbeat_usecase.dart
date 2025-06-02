import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/repositories/repositories.dart';

/// Caso de uso responsável por enviar o sinal de "heartbeat" (ping)
/// via WebSocket para manter a conexão com o servidor ativa.
///
/// Este caso de uso utiliza o [IHeartbeatRepository] para enviar o ping.
/// Após o envio bem-sucedido, o [Stream] é fechado. Caso ocorra erro,
/// o stream emitirá uma exceção.
class HeartbeatUseCase extends CompletableUseCase<FoxbitWebSocket> {
  final IHeartbeatRepository _repository;

  /// Cria uma instância de [HeartbeatUseCase] com o repositório injetado.
  ///
  /// O repositório deve implementar [IHeartbeatRepository] e prover o método
  /// para envio do sinal de heartbeat via WebSocket.
  HeartbeatUseCase(this._repository);

  /// Constrói o [Stream] responsável pelo envio do heartbeat.
  ///
  /// - [params]: Instância ativa de [FoxbitWebSocket] utilizada para
  ///   comunicação com o servidor.
  ///
  /// Retorna um [Stream<void>] que é fechado após o envio do ping.
  /// Em caso de falha ou se [params] for `null`, o stream emitirá um erro.
  @override
  Future<Stream<void>> buildUseCaseStream(FoxbitWebSocket? params) async {
    final controller = StreamController<void>();

    try {
      if (params == null) {
        controller.addError(
          Exception(
            AppStrings.webSocketConnectionError,
          ),
        );
        return controller.stream;
      }

      await _repository.send(params);

      // Fecha o stream após envio bem-sucedido
      controller.close();
    } catch (e) {
      // Emite erro no stream caso ocorra exceção
      controller.addError(e);
    }

    return controller.stream;
  }
}
