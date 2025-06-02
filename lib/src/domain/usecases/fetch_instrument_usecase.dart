import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';
import 'package:foxbit_hiring_test_template/src/domain/repositories/repositories.dart';

/// Caso de uso responsável por buscar a lista de instrumentos de negociação
/// disponíveis via conexão WebSocket.
///
/// Este caso de uso utiliza o [IInstrumentRepository] para obter os dados
/// de negociação a partir de uma instância de [FoxbitWebSocket].
///
/// O resultado da operação é retornado como um [Stream] contendo uma lista
/// de [TradingInstrumentEntity], ou um erro em caso de falha.
class FetchInstrumentsUseCase
    extends UseCase<List<TradingInstrumentEntity>, FoxbitWebSocket> {
  final IInstrumentRepository _instrumentRepo;

  /// Construtor que recebe o repositório de instrumentos.
  ///
  /// O repositório [IInstrumentRepository] deve ser previamente implementado
  /// para fornecer os dados via WebSocket.
  FetchInstrumentsUseCase(this._instrumentRepo);

  /// Constrói o fluxo de execução do caso de uso.
  ///
  /// - [socketConnection]: Instância ativa de [FoxbitWebSocket] que será
  ///   utilizada para comunicação com o servidor.
  ///
  /// Retorna um [Stream] que:
  /// - Emite uma [List<TradingInstrumentEntity>] quando a operação for bem-sucedida.
  /// - Emite um erro (via `addError`) se ocorrer alguma falha na comunicação,
  ///   no repositório ou se a conexão WebSocket for nula.
  @override
  Future<Stream<List<TradingInstrumentEntity>>> buildUseCaseStream(
    FoxbitWebSocket? socketConnection,
  ) async {
    final streamController = StreamController<List<TradingInstrumentEntity>>();

    try {
      // Garante que a conexão WebSocket foi fornecida
      if (socketConnection == null) {
        streamController.addError(
          Exception(
            AppStrings.webSocketConnectionError,
          ),
        );
        return streamController.stream;
      }

      // Requisição ao repositório de instrumentos
      final response = await _instrumentRepo.getInstruments(socketConnection);

      // Trata o resultado da requisição
      response.fold(
        (error) => streamController.addError(error),
        (instrumentsList) {
          streamController.add(instrumentsList);
          streamController.close();
        },
      );
    } catch (exception) {
      // Captura exceções inesperadas e as envia para o stream como erro
      streamController.addError(exception);
    }
    return streamController.stream;
  }
}
