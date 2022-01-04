import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/service/socket_service.dart';

class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${socketService.serverStatus}')
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){ 
         if (socketService.serverStatus == ServerStatus.Online) {
           print('voy a emtiir');
           dynamic message = {'nombre':'Flutter', 'message':'Hola desde Flutter'};
            socketService.socket!.emit('emitir-mensaje', message);
         }
       },
     ),
   );
  }
}