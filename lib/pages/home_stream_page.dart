import 'dart:async';

import 'package:flutter/material.dart';

class HomeStreamPage extends StatefulWidget {
  @override
  State<HomeStreamPage> createState() => _HomeStreamPageState();
}

class _HomeStreamPageState extends State<HomeStreamPage> {
  StreamController<String> _mandarinaStream = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

/*    Stream<int> matasquitaStream = Stream.fromFuture(getDataInt());
    matasquitaStream.listen((event) {
      print("Listen Data::: ${event}");
    }, onDone: (){
      print("Data Done!!");
    }, onError: (error){
      print("Error");
    });*/

/*    _mandarinaStream.stream.listen((event) {
      print("Data recibida ${event}");
    });*/
  }

  Future<int> getDataInt() async {
    return Future.delayed(Duration(seconds: 3), () {
      return 100;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // close para que el Stream deje de estar a la escucha
    _mandarinaStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mandarinaStream.add("Hola muchachos");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Stream"),
        actions: [
          IconButton(
              onPressed: () {
                _mandarinaStream.add("Actions!!!");
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder(
        stream: _mandarinaStream.stream,
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            print(":::::::::::::::: ${snap.data}");
            return Center(
              child: Text(snap.data),
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
