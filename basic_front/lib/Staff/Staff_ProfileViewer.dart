import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:basic_front/NoteAddition.dart';
import 'package:basic_front/NoteView.dart';
import 'package:basic_front/REST/Get_RetrieveNotes.dart';
import 'package:basic_front/Structs/Child.dart';
import 'package:basic_front/Structs/Note.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../Storage.dart';
import '../Structs/Choice.dart';
import '../SuspensionView.dart';

class Staff_ProfileViewer_Page extends StatefulWidget {
  Staff_ProfileViewer_Page({Key key, this.profile, this.child}) : super(key: key);

  final Profile profile;
  final Child child;

  @override
  Staff_ProfileViewer_State createState() => Staff_ProfileViewer_State();
}

class Staff_ProfileViewer_State extends State<Staff_ProfileViewer_Page> {

  final suspensionController = TextEditingController();

  Storage storage;

  final List<int> colorCodes = <int>[600, 500];

  Widget buildPictureNameRow(String firstName, String lastName) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                child: CircleAvatar(
                  backgroundImage: (widget.child.picture != null) ? MemoryImage(base64.decode((widget.child.picture))) : null,
                ),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(20)
                  ),
                ),
                height: 200,
                width: 200,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 10),
              ),
              Flexible(
                child: Text(
                  firstName + "\n" + lastName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.all(10),
    );
  }

  Future<void> checkSuspensionResponse () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuspensionScreen(child: widget.child)),
    ).then((value) {
      setState(() {
      });
    });

    updateSuspension (result);
  }

  updateSuspension (bool isSuspended)
  {
    setState(() {
      suspensionController.text = isSuspended ? "Suspended" : "Not Suspended";
    });
  }

  String checkSuspension ()
  {
    return widget.child.isSuspended ? "Suspended" : "Not Suspended";
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
          buildPictureNameRow(widget.child.firstName, widget.child.lastName),
          buildBirthdayAndGradeRow(widget.child.birthday, widget.child.grade),
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
                            checkSuspensionResponse();
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
                          )
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: FlatButton(
                        child: Text("Add Note", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteAdditionPage(profile: widget.profile, child: widget.child))).then((value) {
                            setState(() {
                            });
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
            FutureBuilder(
                future: storage.readToken().then((value) {
                  return RetrieveNotes(value, widget.child.id);
                }),
                builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Issue Posting Data');
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    case ConnectionState.active:
                      return new Text('');
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text("Press 'Scan QR' to begin!");
                      } else {
                        return Expanded(
                          child: snapshot.data.length > 0
                              ? new ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: ListTile(
                                  title: Text('${snapshot.data[index].content}',
                                      style: TextStyle(color: Colors.white)),
                                  dense: false,
                                  onTap: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteViewPage(note: snapshot.data[index]))).then((value) {
                                      setState(() {
                                      });
                                    });
                                  },
                                ),
                                color: Colors.blue[colorCodes[index%2]],
                                margin: EdgeInsets.only(left: 10, right: 10),
                              );
                            },
                          )
                              : Container(
                            child: Center(
                              child: Text('No Notes Attached!', style: TextStyle(color: Colors.white)),
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.blue,
                              borderRadius: new BorderRadius.only(
                                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),
                              ),
                            ),


                            margin: EdgeInsets.only(left: 10, right: 10),
                          )
                        );
                      }
                      break;
                    default:
                      return null;
                  }
                }
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