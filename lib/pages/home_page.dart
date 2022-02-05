
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference _taskReference =
      FirebaseFirestore.instance.collection("tasks");

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> taskList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    _taskReference.get().then((QuerySnapshot value) {
      List<QueryDocumentSnapshot> docs = value.docs;
      docs.forEach((QueryDocumentSnapshot element) {
        //print(element.id);
        //print(element.data());

        Map<String, dynamic> myMap = element.data() as Map<String, dynamic>;
        taskList.add(myMap);
        //print(myMap);
        /*print(element.id);
        print(myMap["title"]);
        print(myMap["description"]);
        print(myMap["status"]);
        print(myMap["count"]);
        print("x" * 30);*/
      });
      setState(() {});
    });
  }

  void getDataId() {
    _taskReference.doc("AXn1cL1uzwoj76pVbIB2").get().then((value) {
      if (value.exists) {
        print(value.data());
      } else {
        print("El documento no existe");
      }
    });
  }

  void addDocument() {
    _taskReference.add({
      "title": _titleController.text,
      "description": _descriptionController.text,
      "status": false,
    }).then((value) {
      print(value);
      print(value.id);
      print("datos registrados");
      setState(() {});
    }).catchError((error) {
      print("Hubo un error");
    });
  }

  void addDocumentId() {
    _taskReference.doc("A00001").set({
      "title": "conseguir la laptop",
      "description": "Ripley",
      "status": false,
    }).then((value) {
      print("datos registrados");
    }).catchError((error) {
      print("Hubo un error");
    });
  }

  void updateDocument() {
    _taskReference.doc("A00001").update({
      "description": "Saga Falabella",
    }).then((value) {
      print("datos registrados");
      setState(() {});
    }).catchError((error) {
      print("Hubo un error");
    });
  }

  void deleteDocument() {
    _taskReference.doc("A00001").delete().then((value) {
      print("documento eliminado");
    }).catchError((error) {
      print("Hubo un error");
    });
  }

  showAddForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Agregar Tarea"),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Titulo",
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Descripción",
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addDocument();
                Navigator.pop(context);
              },
              child: Text(
                "Agregar",
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Task"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //getData();
          //getDataId();
          //addDocument();
          //addDocumentId();
          //updateDocument();
          //deleteDocument();
          showAddForm();
        },
        child: Icon(Icons.add),
      ),
      /*body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(taskList[index]["title"]),
            subtitle: Text(taskList[index]["description"]),
          );
        },
      ),*/
      body: FutureBuilder(
        future: _taskReference.get(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          //print(snap.connectionState);
          if (snap.hasData) {
            QuerySnapshot collection = snap.data;
            //print(collection.docs);
            return ListView.builder(
              itemCount: collection.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> myMap =
                    collection.docs[index].data() as Map<String, dynamic>;
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.redAccent,),
                  direction: DismissDirection.startToEnd,
                  movementDuration: const Duration(seconds: 1),
                  onDismissed: (DismissDirection direction){
                    print("${myMap["title"]} eliminado");
                  },
                  child: ListTile(
                    title: Text(myMap["title"]),
                    subtitle: Text(myMap["description"]),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
