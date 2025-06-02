import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';
import 'package:foxbit_hiring_test_template/src/domain/repositories/repositories.dart';

/// Caso de uso para inscrição em atualizações de cotação de um instrumento.
///
/// Recebe parâmetros com a conexão WebSocket e o identificador do instrumento,
/// retorna um stream de [MarketQuoteEntity] com as cotações em tempo real.
class SubscribeQuoteUseCase
    extends UseCase<MarketQuoteEntity, QuoteSubscriptionParameters> {
  final IQuoteRepository repository;

  SubscribeQuoteUseCase(this.repository);

  /// Constrói o stream que emitirá as cotações do instrumento informado.
  ///
  /// Caso [params] seja `null`, o stream emitirá um erro de argumento inválido.
  /// Inicialmente tenta se inscrever e obter a cotação atual via [subscribeToQuote].
  /// Depois, escuta atualizações futuras via [getQuoteStream].
  ///
  /// Em caso de falha, erros são emitidos no stream.
  @override
  Future<Stream<MarketQuoteEntity>> buildUseCaseStream(
    QuoteSubscriptionParameters? params,
  ) async {
    final controller = StreamController<MarketQuoteEntity>();

    if (params == null) {
      controller.addError(
        ArgumentError(
          AppStrings.nullParamsErrorMessage,
        ),
      );
      await controller.close();
      return controller.stream;
    }

    try {
      // Inscreve para receber a cotação inicial
      final result = await repository.subscribeToQuote(
        params.socketConnection as FoxbitWebSocket,
        params.instrumentIdentifier,
      );

      result.fold(
        (failure) => controller.addError(failure),
        (quote) => controller.add(quote),
      );

      // Escuta atualizações futuras da cotação e adiciona no stream
      repository.getQuoteStream(params.instrumentIdentifier).listen(
        (either) {
          either.fold(
            (failure) => controller.addError(failure),
            (quote) => controller.add(quote),
          );
        },
        onError: (error) => controller.addError(error.toString()),
      );
    } catch (e) {
      controller.addError(e);
    }

    return controller.stream;
  }
}
