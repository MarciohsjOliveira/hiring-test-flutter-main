import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/data/data.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

import 'package:rxdart/rxdart.dart';

/// Implementação concreta de [IQuoteRepository] responsável por:
/// - Assinar cotações de mercado em tempo real via WebSocket (SubscribeLevel1).
/// - Fornecer um stream contínuo das atualizações da cotação para um determinado instrumento.
///
/// Utiliza a estrutura [BehaviorSubject] para emitir atualizações reativas a cada nova
/// mensagem recebida via WebSocket, convertendo os dados para [MarketQuoteEntity].
///
/// Retorna os dados encapsulados com [Either], permitindo lidar com falhas (ex: [ServerFailure], [WebSocketFailure]).
class QuoteRepository implements IQuoteRepository {
  /// Nome do evento enviado via WebSocket para assinar as cotações.
  final String _eventName = 'SubscribeLevel1';

  /// Armazena streams reativos por instrumento (InstrumentId),
  /// onde cada stream emite [Either<Failure, MarketQuoteEntity>].
  final Map<int, BehaviorSubject<Either<Failure, MarketQuoteEntity>>> _quoteStreams = {};

  /// Realiza a inscrição para receber cotações de um [instrumentId] específico.
  ///
  /// Envia um evento `SubscribeLevel1` via WebSocket [ws] e aguarda pela primeira
  /// resposta válida com o mesmo ID ou contendo o InstrumentId correspondente.
  ///
  /// A partir de então, escuta continuamente novas mensagens relacionadas àquele instrumento
  /// e as emite no stream interno para o consumidor.
  ///
  /// Retorna a primeira cotação recebida (ou falha, encapsulada em [Either]).
  @override
  Future<Either<Failure, MarketQuoteEntity>> subscribeToQuote(
    FoxbitWebSocket ws,
    int instrumentId,
  ) async {
    try {
      // Cria o stream para o instrumento, se ainda não existir
      _quoteStreams[instrumentId] ??=
          BehaviorSubject<Either<Failure, MarketQuoteEntity>>();

      // Envia o pedido de inscrição via WebSocket
      ws.send(_eventName, {'InstrumentId': instrumentId});

      // Aguarda a primeira resposta correspondente
      final message = await ws.stream
          .where(
            (message) =>
                message['n'].toString() == _eventName &&
                (message['i'] == ws.lastId ||
                    (_isMapWithInstrumentId(message['o'], instrumentId))),
          )
          .first;

      // Verifica se a resposta é válida
      if (message['o'] == null) {
        final failure = Left<Failure, MarketQuoteEntity>(ServerFailure());
        _quoteStreams[instrumentId]?.add(failure);
        return failure;
      }

      final Map<String, dynamic> quoteJson = _parseMessageContent(message['o']);

      if (quoteJson.isEmpty) {
        final failure = Left<Failure, MarketQuoteEntity>(ServerFailure());
        _quoteStreams[instrumentId]?.add(failure);
        return failure;
      }

      // Converte a resposta em entidade de domínio
      final MarketQuoteEntity quote = QuoteModel.fromJson(quoteJson);
      final result = Right<Failure, MarketQuoteEntity>(quote);

      // Emite o resultado no stream associado
      _quoteStreams[instrumentId]?.add(result);

      // Escuta atualizações futuras para esse instrumento
      ws.stream
          .where(
            (message) =>
                message['n'].toString() == _eventName &&
                _isMapWithInstrumentId(message['o'], instrumentId),
          )
          .listen((message) {
        try {
          final Map<String, dynamic> quoteJson =
              _parseMessageContent(message['o']);

          if (quoteJson.isNotEmpty) {
            final MarketQuoteEntity quote = QuoteModel.fromJson(quoteJson);
            _quoteStreams[instrumentId]?.add(Right(quote));
          }
        } catch (e) {
          _quoteStreams[instrumentId]?.add(Left(ServerFailure()));
        }
      });

      return result;
    } catch (e) {
      final failure = Left<Failure, MarketQuoteEntity>(WebSocketFailure());
      _quoteStreams[instrumentId]?.add(failure);
      return failure;
    }
  }

  /// Retorna o stream reativo das cotações para um [instrumentId] específico.
  ///
  /// Se ainda não houver stream criado para esse instrumento, retorna um stream
  /// contendo um [ServerFailure] por padrão.
  @override
  Stream<Either<Failure, MarketQuoteEntity>> getQuoteStream(int instrumentId) {
    return _quoteStreams[instrumentId]?.stream ??
        Stream.value(Left(ServerFailure()));
  }

  /// Verifica se [data] contém o campo `InstrumentId` igual ao [instrumentId] desejado.
  ///
  /// Aceita tanto Map quanto String JSON decodável.
  bool _isMapWithInstrumentId(dynamic data, int instrumentId) {
    if (data is Map) {
      return data['InstrumentId'] == instrumentId;
    }

    if (data is String) {
      try {
        final decoded = json.decode(data);
        return decoded is Map && decoded['InstrumentId'] == instrumentId;
      } catch (_) {
        return false;
      }
    }

    return false;
  }

  /// Converte o conteúdo da mensagem [content] em um [Map<String, dynamic>], se possível.
  ///
  /// Suporta strings JSON ou Map nativo.
  Map<String, dynamic> _parseMessageContent(dynamic content) {
    if (content is String) {
      try {
        final decoded = json.decode(content);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        return <String, dynamic>{};
      } catch (_) {
        return <String, dynamic>{};
      }
    }

    if (content is Map) {
      return Map<String, dynamic>.from(content);
    }

    return <String, dynamic>{};
  }
}
