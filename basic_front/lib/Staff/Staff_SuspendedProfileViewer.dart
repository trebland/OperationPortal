import 'dart:convert';

import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:basic_front/Structs/Child.dart';
import 'package:basic_front/Structs/SuspendedChild.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../Storage.dart';
import '../Structs/Choice.dart';
import '../SuspensionView.dart';

class Staff_SuspendedProfileViewer_Page extends StatefulWidget {
  Staff_SuspendedProfileViewer_Page({Key key, this.child}) : super(key: key);

  final SuspendedChild child;

  @override
  Staff_SuspendedProfileViewer_State createState() => Staff_SuspendedProfileViewer_State();
}

class Staff_SuspendedProfileViewer_State extends State<Staff_SuspendedProfileViewer_Page> {

  final suspensionController = TextEditingController();
  bool isAddingNote = false;

  List<String> notes = ["Doesn't play well with Henry", "Loves Juice", "Dislikes Soccer", "Likes Monopoly"];

  Storage storage;

  final List<int> colorCodes = <int>[600, 500];

  @override
  void initState() {
    storage = new Storage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.firstName +  " " + widget.child.lastName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildPictureNameRow_Child(widget.child.firstName +  " " + widget.child.lastName),
          buildBirthdayAndGradeRow(),
          Container(
            child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>
                  [
                    Container(
                      child: Text(
                        "Notes",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                        borderRadius: new BorderRadius.only(
                          topRight: new Radius.circular(20), topLeft: new Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: FlatButton(
                        child: Text("Add Note", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            isAddingNote = isAddingNote ?  false :  true;
                          });
                        },
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                        borderRadius: new BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      margin: EdgeInsets.only(left: 20),
                    ),
                  ]
              ),
            ),
            margin: EdgeInsets.only(top: 10, left: 10),
          ),
          isAddingNote ? Container(
            child: TextField(
              textAlign: TextAlign.left,
              decoration: new InputDecoration(
                labelText: "Note Addition",
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  borderSide: new BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ) : Container(),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      title: Text('${notes[index]}',
                          style: TextStyle(color: Colors.white)),
                      trailing: PopupMenuButton<Choice>(
                        onSelected: _select,
                        itemBuilder: (BuildContext context) {
                          return ReturnDummyList();
                        },
                      ),
                      dense: false,
                    ),
                    color: Colors.blue[colorCodes[index%2]],
                  );
                },
              ),
              margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuItem<Choice>> ReturnDummyList ()
  {
    List<PopupMenuItem<Choice>> list = new List<PopupMenuItem<Choice>>();
    list.add(PopupMenuItem<Choice>(
      value: new Choice("Edit"),
      child: Text("Edit"),
    ));
    return list;
  }

  void _select(Choice value) {
  }
}