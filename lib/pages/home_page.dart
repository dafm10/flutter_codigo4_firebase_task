import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo4_firebase_task/ui/widget/general_widget.dart';

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

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
    getTest();
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

  getTest() {
    _taskReference.orderBy('count').limit(2).get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
      });
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
      //print(value);
      //print(value.id);
      print("datos registrados");
      // al usar stream, no requerimos setState
      //setState(() {});
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

  void updateDocument(String id, bool value) {
    _taskReference.doc(id).update({
      "status": value,
    }).then((value) {
      showSnackErrorMessage(
        context, "check", "Datos actualizados",
      );
      isLoading = false;
      setState(() {});
    }).catchError((error) {
      print("Hubo un error");
    });
  }

  void deleteDocument(String id) {
    _taskReference.doc(id).delete().then((value) {
      //print("documento eliminado");
    }).catchError((error) {
      showSnackErrorMessage(
        context, "error", "Ocurrió un error",
      );
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
                _titleController.clear();
                _descriptionController.clear();
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
      /*body: FutureBuilder(
        future: _taskReference.get(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          //print(snap.connectionState);
          if (snap.hasData) {
            QuerySnapshot collection = snap.data;
            //print(collection.docs);
            return !isLoading ? ListView.builder(
              itemCount: collection.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> myMap =
                    collection.docs[index].data() as Map<String, dynamic>;
                myMap["id"] = collection.docs[index].id;
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.redAccent,
                  ),
                  direction: DismissDirection.startToEnd,
                  movementDuration: const Duration(seconds: 1),
                  onDismissed: (DismissDirection direction) {
                    print(myMap["id"]);
                    deleteDocument(myMap["id"]);
                    showSnackErrorMessage(
                      context, "check", "${myMap["title"]} se ha eliminado",
                    );
                  },
                  child: ListTile(
                    title: Text(myMap["title"]),
                    subtitle: Text(myMap["description"]),
                    trailing: IconButton(
                      onPressed: () {
                        isLoading = true;
                        setState(() {

                        });
                        myMap["status"] = !myMap["status"];
                        updateDocument(myMap["id"], myMap["status"]);
                      },
                      icon: Icon(Icons.check_circle),
                      color: myMap["status"]
                          ? Colors.green
                          : Colors.black26.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ) : Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),*/
      body: StreamBuilder(
        stream: _taskReference.snapshots(),
        builder: (BuildContext context,AsyncSnapshot snap){
          if(snap.hasData){
            QuerySnapshot collection = snap.data;
            return ListView.builder(
              itemCount: collection.docs.length,
              itemBuilder: (context, index){
                return Text(collection.docs[index]["title"]);
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
