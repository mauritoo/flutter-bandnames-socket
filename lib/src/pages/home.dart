import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/service/socket_service.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController textController = TextEditingController();
  List<Band> bands = [
    // Band(id: '1', name: 'La Renga', votes: 92),
    // Band(id: '2', name: 'Attaque', votes: 104),
    // Band(id: '3', name: 'Los Fabulosos Cadillacs', votes: 600),
    // Band(id: '4', name: 'La Portuaria', votes: 403),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket!.on('active-bands', (payload) {
      print(payload);
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {
        
      });
    });   

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket!.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online 
                ? const Icon(Icons.check_circle_rounded, color: Colors.green)
                : const Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
        ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: addBand,),
   );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direction: $direction');
        print('name: ${band.name}');
        _deleteBand(band);
      },
      key: Key(band.id!),
      background: Container(
        padding: const EdgeInsets.only(left: 8.9),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('DELETE BAND', style: TextStyle(color: Colors.white)))
      ),
      child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(band.name!.substring(0, 2))),
            title: Text(band.name!),
            trailing: Text(band.votes.toString(), style: const TextStyle(fontSize: 20)),
            onTap: () => _voteBand(band)
          ),
    );
  }

  void addBand() {

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('New band name:'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              elevation: 5,
              child: const Text('ADD', style: TextStyle(color: Colors.blue)),
              onPressed: (){
                addBandToList(textController.text);
              } )
          ],
        );
      });
  }

  void addBandToList (String name) {
    print(name);
    
    if (name.isNotEmpty){
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket!.emit('add-band', {'name': name});    
    }
    Navigator.pop(context);
  }

  _voteBand(Band band) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket!.emit('vote-band', {'id': band.id});    
  }

  _deleteBand(Band band) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket!.emit('delete-band', {'id': band.id});    
  }
}