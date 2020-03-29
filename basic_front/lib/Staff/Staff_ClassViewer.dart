import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:basic_front/NoteAddition.dart';
import 'package:basic_front/NoteView.dart';
import 'package:basic_front/REST/Get_RetrieveBusInfo.dart';
import 'package:basic_front/REST/Get_RetrieveClassInfo.dart';
import 'package:basic_front/REST/Get_RetrieveNotes.dart';
import 'package:basic_front/Structs/Bus.dart';
import 'package:basic_front/Structs/Class.dart';
import 'package:basic_front/Structs/RosterChild.dart';
import 'package:basic_front/Structs/Note.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/User.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../Storage.dart';
import '../Structs/Choice.dart';
import '../SuspensionView.dart';

class Staff_ClassViewer_Page extends StatefulWidget {
  Staff_ClassViewer_Page({Key key, this.user, this.classId}) : super(key: key);

  final User user;
  final String classId;

  @override
  Staff_ClassViewer_State createState() => Staff_ClassViewer_State();
}

class Staff_ClassViewer_State extends State<Staff_ClassViewer_Page> {

  Storage storage;

  @override
  void initState() {
    storage = new Storage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Info"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*
            “bus”:
            {"id": int,
            "driverId": int,
            "driverName": "string",
            "name": "string",
            "route": "string",
            "lastOilChange": DateTime,
            "lastTireChange": DateTime,
            "lastMaintenance": DateTime
          */
          FutureBuilder(
              future: storage.readToken().then((value) {
                return RetrieveClassInfo(value, widget.classId, context);
              }),
              builder: (BuildContext context, AsyncSnapshot<Class> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text('Issue Posting Data');
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  case ConnectionState.active:
                    return new Text('');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Unable to Fetch Class Info"),
                      );
                    } else {
                      return Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text("Name:\n${snapshot.data.teacherName}", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),),
                                decoration: new BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20)
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  top: 20,
                                ),
                                padding: EdgeInsets.all(20),
                              ),
                            ],
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