import 'dart:convert';
import 'dart:typed_data';

import 'package:operationportal/BuildPresets/Child_ProfileViewer.dart';
import 'package:operationportal/NoteAddition.dart';
import 'package:operationportal/NoteView.dart';
import 'package:operationportal/REST/Get_RetrieveBusInfo.dart';
import 'package:operationportal/REST/Get_RetrieveClassInfo.dart';
import 'package:operationportal/REST/Get_RetrieveNotes.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Note.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../Storage.dart';
import '../Structs/Choice.dart';
import '../SuspensionView.dart';

class Staff_ClassViewer_Page extends StatefulWidget {
  Staff_ClassViewer_Page({Key key, this.mClass}) : super(key: key);

  final Class mClass;

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
          Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text("Name:\n${widget.mClass.teacherName}", textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
  }
}