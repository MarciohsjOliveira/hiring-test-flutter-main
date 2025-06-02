import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/io.dart';

/// [FoxbitWebSocket] é uma classe responsável por gerenciar a conexão
/// com o WebSocket da API da Foxbit (https://api.foxbit.com.br), permitindo
/// envio e recebimento de mensagens em tempo real.
///
/// A classe implementa:
/// - Conexão e desconexão do WebSocket.
/// - Reenvio automático em caso de desconexão acidental.
/// - Preparação e envio de mensagens com ID incremental.
/// - Decodificação e emissão de mensagens recebidas para ouvintes via [stream].
///
/// Ela usa [BehaviorSubject] para emitir os dados recebidos
/// e [rxdart] para controle reativo.
class FoxbitWebSocket {
  /// Canal de comunicação WebSocket.
  late IOWebSocketChannel _socket;

  /// ID incremental utilizado nas mensagens enviadas.
  int _id = 0;

  /// Flag para saber se a conexão foi iniciada manualmente.
  bool _connectedByUser = false;

  /// Indica se o WebSocket está conectado.
  bool connected = false;

  /// Tamanho do incremento do ID a cada mensagem enviada.
  final int _idStepSize = 2;

  /// Stream controlada que emite os dados decodificados recebidos do WebSocket.
  @protected
  final BehaviorSubject<Map> streamController = BehaviorSubject<Map>();

  /// Retorna o último ID utilizado antes do incremento.
  int get lastId => _id - _idStepSize;

  /// Construtor que instancia e conecta ao WebSocket com base na origem (iOS/Android).
  FoxbitWebSocket() {
    final origin = _getOrigin();
    _socket = IOWebSocketChannel.connect('wss://api.foxbit.com.br?origin=$origin');
  }

  /// Estabelece a conexão com o WebSocket e escuta mensagens do canal.
  void connect() {
    final origin = _getOrigin();
    _socket = IOWebSocketChannel.connect(
      Uri.parse('wss://api.foxbit.com.br?origin=$origin'),
    );

    _connectedByUser = true;
    connected = true;
    _id = 0;

    _socket.stream.listen(
      onMessage,
      onDone: _onDone,
      cancelOnError: false,
    );
  }

  /// Encerra a conexão com o WebSocket.
  Future<void> disconnect() async {
    _connectedByUser = false;
    connected = false;
    await _socket.sink.close();
  }

  /// Envia uma mensagem codificada para o WebSocket, usando o [method] e os [data] fornecidos.
  void send(String method, dynamic data) {
    _socket.sink.add(prepareMessage(method, data));
  }

  /// Stream pública exposta para ouvir mensagens decodificadas do WebSocket.
  Stream<Map> get stream => streamController.stream;

  /// Prepara a mensagem no formato esperado pela API da Foxbit.
  /// O campo `"i"` é o ID da mensagem, e `"o"` é o corpo serializado.
  @protected
  String prepareMessage(String method, dynamic objectData) {
    final Map data = {
      "m": 0,
      "i": _id,
      "n": method,
      "o": json.encode(objectData),
    };

    _id += _idStepSize;

    return json.encode(data);
  }

  /// Trata mensagens recebidas do WebSocket, decodifica os dados e adiciona à [streamController].
  @protected
  void onMessage(dynamic message) {
    final Map data = json.decode(message.toString()) as Map;

    if (data['o'].toString().isNotEmpty) {
      data['o'] = json.decode(data['o'].toString());
    }

    streamController.add(data);
  }

  /// Handler chamado ao encerrar a conexão. Se a conexão foi feita pelo usuário,
  /// tenta reconectar automaticamente após 1 segundo.
  void _onDone() {
    if (_connectedByUser) {
      _reconnect();
    }
  }

  /// Tenta reconectar após um pequeno atraso.
  void _reconnect() {
    Timer(const Duration(seconds: 1), () async {
      connect();
    });
  }

  /// Obtém a origem da plataforma atual ('iOS', 'Android' ou 'Unknown').
  String _getOrigin() {
    if (Platform.isIOS) {
      return AppStrings.appTitleIOS;
    } else if (Platform.isAndroid) {
      return AppStrings.appTitleAndroid;
    } else {
      return AppStrings.appTitleUnknown;
    }
  }
}
