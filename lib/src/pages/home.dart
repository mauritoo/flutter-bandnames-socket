import 'package:band_names/src/models/band.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'La Renga', votes: 92),
    Band(id: '2', name: 'Attaque', votes: 104),
    Band(id: '3', name: 'Los Fabulosos Cadillacs', votes: 600),
    Band(id: '4', name: 'La Portuaria', votes: 403),
  ];
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
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
            onTap: () => print(band.name!)
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
      bands.add(
        Band(id: DateTime.now().toString(), name: name, votes: 0)
      );
      setState(() {
        
      });
    }
    Navigator.pop(context);
  }
}