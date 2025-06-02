import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

/// Implementação de [IInstrumentRepository] responsável por obter
/// a lista de instrumentos de negociação através de uma conexão WebSocket.
class InstrumentRepository implements IInstrumentRepository {
  /// Nome do evento enviado via WebSocket para solicitar instrumentos.
  final String _eventName = 'getInstruments';

  /// Obtém a lista de instrumentos de negociação da API WebSocket.
  ///
  /// Envia um evento de requisição via WebSocket usando [FoxbitWebSocket].
  /// Aguarda uma resposta válida contendo a lista de instrumentos no campo `o`.
  ///
  /// Retorna um [Either] com:
  /// - [Right]: lista de [TradingInstrumentEntity] em caso de sucesso.
  /// - [Left]: uma instância de [Failure] se ocorrer um erro na conexão ou nos dados.
  @override
  Future<Either<Failure, List<TradingInstrumentEntity>>> getInstruments(
    FoxbitWebSocket ws,
  ) async {
    try {
      // Envia o evento de requisição
      ws.send(_eventName, {});

      // Aguarda a primeira mensagem de resposta correspondente ao evento
      final message = await ws.stream.firstWhere(
        (message) =>
            message['n'].toString() == _eventName && message['i'] == ws.lastId,
      );

      // Verifica se há dados no campo 'o'
      if (message['o'] == null) {
        return Left(ServerFailure());
      }

      // Converte o campo 'o' em uma lista de objetos JSON
      final List<dynamic> instrumentsJson = _parseInstrumentsData(message['o']);

      // Se estiver vazio, considera erro
      if (instrumentsJson.isEmpty) {
        return Left(ServerFailure());
      }

      // Converte os JSONs em entidades de domínio
      final List<TradingInstrumentEntity> instruments = [];

      for (final json in instrumentsJson) {
        if (json is Map<String, dynamic>) {
          instruments.add(TradingInstrumentModel.fromJson(json));
        }
      }

      return Right(instruments);
    } catch (e) {
      // Em caso de erro na conexão ou parsing, retorna falha
      return Left(WebSocketFailure());
    }
  }

  /// Converte a resposta do campo 'o' da mensagem WebSocket
  /// em uma lista de objetos dinâmicos.
  ///
  /// Se os dados forem uma string JSON válida representando uma lista, decodifica.
  /// Caso contrário, se já for uma lista, retorna diretamente.
  /// Retorna uma lista vazia em caso de falha.
  List<dynamic> _parseInstrumentsData(dynamic data) {
    if (data is String) {
      try {
        final decoded = json.decode(data);
        if (decoded is List) {
          return decoded;
        }
        return [];
      } catch (_) {
        return [];
      }
    }

    if (data is List) {
      return data;
    }

    return [];
  }
}
