import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connection,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connection;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  _initConfig() {
    this._socket = IO.io('http://192.168.1.74:3001/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //ESCUCHAR UN EVENTO PERSONALIZADO
    // socket.on('nuevo-mensaje', (payload) {
    //   print('NUEVO MENSAJE: ${payload}');
    //   //print(payload['nombre']);
    //   //VERIFICA SI EL OBJETO payload CONTIENEN UN ELEMENTO QUE SE LLAMA MENSAJE2
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    // });
  }
}
