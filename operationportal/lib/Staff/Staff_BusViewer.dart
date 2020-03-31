import 'dart:convert';
import 'dart:typed_data';

import 'package:operationportal/BuildPresets/Child_ProfileViewer.dart';
import 'package:operationportal/NoteAddition.dart';
import 'package:operationportal/NoteView.dart';
import 'package:operationportal/REST/Get_RetrieveBusInfo.dart';
import 'package:operationportal/REST/Get_RetrieveNotes.dart';
import 'package:operationportal/Structs/Bus.dart';
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

class Staff_BusViewer_Page extends StatefulWidget {
  Staff_BusViewer_Page({Key key, this.bus}) : super(key: key);

    final Bus bus;

  @override
  Staff_BusViewer_State createState() => Staff_BusViewer_State();
}

class Staff_BusViewer_State extends State<Staff_BusViewer_Page> {

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
  Storage storage;
  Bus bus;

  @override
  void initState() {
    storage = new Storage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Info"),
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
                    child: Text("Name:\n${widget.bus.driverName}", textAlign: TextAlign.center,
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