import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  CollectionReference _taskReference =
      FirebaseFirestore.instance.collection("tasks");

  getData() {
    _taskReference.get().then((QuerySnapshot value) {
      List<QueryDocumentSnapshot> docs = value.docs;
      docs.forEach((QueryDocumentSnapshot element) {
        //print(element.id);
        //print(element.data());

        Map<String, dynamic> myMap = element.data() as Map<String, dynamic>;
        print(myMap);
        /*print(element.id);
        print(myMap["title"]);
        print(myMap["description"]);
        print(myMap["status"]);
        print(myMap["count"]);
        print("x" * 30);*/
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
      "title": "Comprar disco",
      "description": "Coolbox",
      "status": false,
    }).then((value) {
      print(value);
      print(value.id);
      print("datos registrados");
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
    _taskReference
        .doc("A00001")
        .update({
          "description": "Saga Falabella",
        })
        .then((value) {
      print("datos registrados");
    }).catchError((error) {
      print("Hubo un error");
    });
  }

  void deleteDocument(){
    _taskReference.doc("A00001").delete().then((value) {
      print("documento eliminado");
    }).catchError((error) {
      print("Hubo un error");
    });
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
          deleteDocument();
        },
        child: Icon(Icons.add),
      ),
      body: Center(),
    );
  }
}
