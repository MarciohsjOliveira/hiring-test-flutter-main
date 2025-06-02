import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/repositories/i_heartbeat_repository.dart';

/// Implementação do repositório responsável por enviar o evento de heartbeat ("PING")
/// através do WebSocket da Foxbit e aguardar pela resposta correspondente.
///
/// Esta classe comunica-se com a API via WebSocket, enviando um evento "PING" e
/// escutando a primeira mensagem recebida cujo nome (`n`) corresponda ao evento enviado,
/// e cujo identificador (`i`) coincida com o último ID gerado pela conexão.
///
/// Esse mecanismo é útil para verificar se a conexão WebSocket está ativa
/// e operando corretamente.
///
/// Exemplo de uso:
/// ```dart
/// final heartbeat = await HeartbeatRepository().send(ws);
/// print(heartbeat); // resposta esperada do servidor
/// ```
class HeartbeatRepository implements IHeartbeatRepository {
  /// Nome do evento enviado via WebSocket.
  final String _eventName = 'PING';

  /// Envia um evento `PING` para o WebSocket fornecido [ws] e aguarda
  /// a primeira resposta válida do servidor com o mesmo nome de evento (`n`)
  /// e o ID correspondente ao último enviado (`ws.lastId`).
  ///
  /// Retorna um `Future<Map>` contendo a mensagem recebida.
  ///
  /// A mensagem esperada é semelhante a:
  /// ```json
  /// {
  ///   "m": 0,
  ///   "i": 0,
  ///   "n": "PING",
  ///   "o": { ... }
  /// }
  /// ```
  @override
  Future<Map> send(FoxbitWebSocket ws) {
    // Envia o evento PING via WebSocket
    ws.send(_eventName, {});
    
    // Aguarda a primeira mensagem recebida que:
    // - Tenha o nome igual ao evento enviado (ignorando maiúsculas/minúsculas)
    // - Possua o mesmo ID gerado no envio
    return ws.stream.firstWhere(
      (message) =>
          message['n'].toString().toUpperCase() == _eventName &&
          message['i'] == ws.lastId,
    );
  }
}
