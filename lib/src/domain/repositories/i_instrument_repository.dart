import 'package:dartz/dartz.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';

/// Abstração do repositório responsável por fornecer os instrumentos de negociação.
///
/// Um instrumento de negociação representa um par de ativos (por exemplo, BTC/BRL),
/// utilizado nas operações de compra e venda.
abstract class IInstrumentRepository {
  /// Obtém a lista de instrumentos disponíveis para negociação através do WebSocket.
  ///
  /// [webSocket] - Instância do [FoxbitWebSocket] usada para se comunicar com a API via WebSocket.
  ///
  /// Retorna um [Either] contendo:
  /// - [Right] com uma lista de [TradingInstrumentEntity] em caso de sucesso.
  /// - [Left] com um [Failure] em caso de erro (ex: problemas de conexão ou resposta inválida).
  Future<Either<Failure, List<TradingInstrumentEntity>>> getInstruments(
    FoxbitWebSocket webSocket,
  );
}
