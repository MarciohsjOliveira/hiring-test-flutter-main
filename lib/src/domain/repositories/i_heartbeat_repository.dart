
import 'package:foxbit_hiring_test_template/src/core/core.dart';

/// Contrato para repositórios que enviam sinais de heartbeat (ping) via WebSocket.
abstract class IHeartbeatRepository {
  /// Envia um sinal de heartbeat utilizando a conexão WebSocket fornecida.
  ///
  /// [webSocket] - Instância do [FoxbitWebSocket] para envio do sinal.
  ///
  /// Retorna um [Future] que resolve com um [Map] contendo a resposta do servidor.
  Future<Map> send(FoxbitWebSocket webSocket);
}
