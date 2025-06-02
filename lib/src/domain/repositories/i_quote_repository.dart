import 'package:dartz/dartz.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/entities/entities.dart';

/// Repositório responsável por manipular dados de cotações de mercado.
abstract class IQuoteRepository {
  /// Realiza a inscrição para receber a cotação em tempo real de um instrumento específico.
  ///
  /// [webSocket] - Conexão WebSocket ativa utilizada para enviar a requisição.
  /// [instrumentId] - Identificador do instrumento para o qual deseja receber a cotação.
  ///
  /// Retorna [Either] com um [MarketQuoteEntity] no caso de sucesso ou [Failure] em caso de erro.
  Future<Either<Failure, MarketQuoteEntity>> subscribeToQuote(
    FoxbitWebSocket webSocket,
    int instrumentId,
  );

  /// Retorna uma stream contínua de cotações atualizadas de um instrumento específico.
  ///
  /// [instrumentId] - Identificador do instrumento para receber atualizações.
  ///
  /// Retorna uma [Stream] que emite [Either<Failure, MarketQuoteEntity>] com atualizações ou falhas.
  Stream<Either<Failure, MarketQuoteEntity>> getQuoteStream(
    int instrumentId,
  );
}
