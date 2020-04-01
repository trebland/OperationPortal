import 'dart:convert';

import 'package:operationportal/NoteAddition/AddNote.dart';
import 'package:operationportal/NoteAddition/NoteView.dart';
import 'package:operationportal/REST/Get_RetrieveNotes.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Note.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:operationportal/Widget/SuspensionView.dart';

class ChildProfileViewerPage extends StatefulWidget {
  ChildProfileViewerPage({Key key, this.user, this.child}) : super(key: key);

  final User user;
  final RosterChild child;

  @override
  ChildProfileViewerState createState() => ChildProfileViewerState();
}

class ChildProfileViewerState extends State<ChildProfileViewerPage> {

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
    );

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

  DateTime parseBirthday (String birthday)
  {
    List<String> dateBreak = new List<String>();
    dateBreak = birthday.split('/');
    return DateTime(int.parse(dateBreak[2]), int.parse(dateBreak[0]), int.parse(dateBreak[1]));
  }

  int calculateBirthday(String birthday)
  {
    return (DateTime.now().difference(parseBirthday(birthday.split(' ')[0])).inDays ~/ 365.25);
  }

  Widget buildBirthdayAndGradeRow (String birthday, int grade)
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Age",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        birthday != null && birthday.isNotEmpty ? '${calculateBirthday(birthday)}' : "N/A",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Birthday",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        birthday != null && birthday.isNotEmpty ? birthday.split(' ')[0] : "N/A",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Grade",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: Text(
                          grade != null ? '$grade' : "N/A",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
    );
  }

  /*Widget buildContactInformationRow()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Contact Number",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.child != null && birthday.isNotEmpty ? '${calculateBirthday(birthday)}' : "N/A",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Birthday",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        birthday != null && birthday.isNotEmpty ? birthday.split(' ')[0] : "N/A",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Grade",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: Text(
                          grade != null ? '$grade' : "N/A",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
              ),
            ]
        ),
      ),
      margin: EdgeInsets.all(10),
    );
  }*/

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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(profile: widget.user.profile, child: widget.child))).then((value) {
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
}