import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => _socket;

  SocketService(){
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io('http://192.168.0.7:3000', IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

    try{
      _socket!.connect();
    } catch(e) {
      log('error al querer conectar');
    } 

    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket!.on('nuevo-mensaje', (payload) {
      print('Nuevo mensaje: $payload');
    });

  }

}