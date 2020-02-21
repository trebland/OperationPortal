import 'dart:convert';

import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:basic_front/Structs/Child.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../Storage.dart';
import '../Structs/Choice.dart';
import '../SuspensionView.dart';

class NotesEditResponse {
  String notes;

  NotesEditResponse({this.notes});

  factory NotesEditResponse.fromJson(Map<String, dynamic> json) {
    return NotesEditResponse(
      notes: json['notes'],
    );
  }
}

Future<void> EditNotes (String token, int id, String notes)
async {
  var mUrl = "https://www.operation-portal.com/api/notes-edit";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var body = json.encode({
    'id': id,
    'notes': notes,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: headers);

  if (response.statusCode == 200) {

    NotesEditResponse mPost = NotesEditResponse.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.notes,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

  } else {

    return null;
  }
}


class Staff_ProfileViewer_Page extends StatefulWidget {
  Staff_ProfileViewer_Page({Key key, this.child}) : super(key: key);

  final Child child;

  @override
  Staff_ProfileViewer_State createState() => Staff_ProfileViewer_State();
}

class Staff_ProfileViewer_State extends State<Staff_ProfileViewer_Page> {

  final suspensionController = TextEditingController();
  bool isSuspended = false;
  bool isAddingNote = false;

  List<String> notes = ["Doesn't play well with Henry", "Loves Juice", "Dislikes Soccer", "Likes Monopoly"];

  Storage storage;

  final List<int> colorCodes = <int>[600, 500];

  toggleSuspension ()
  {
    if (isSuspended)
      isSuspended = false;
    else
      isSuspended = true;
    suspensionController.text = checkSuspension();
  }

  String checkSuspension ()
  {
    return isSuspended ? "Suspended" : "Not Suspended";
  }

  @override
  void initState() {
    suspensionController.text = checkSuspension();
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>
                    [
                      Container(
                        child: FlatButton(
                          child: Text("Suspend", style: TextStyle(color: Colors.white)),
                          onPressed: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SuspensionScreen(child: widget.child)));
                            }
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        margin: EdgeInsets.only(left: 20),
                      ),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: suspensionController,
                          decoration: new InputDecoration(
                            labelText: "Suspension Status",
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
                          enabled: false,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ]
                ),
              ),
              margin: EdgeInsets.only(top: 25, left: 25, right: 25),
            ),
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