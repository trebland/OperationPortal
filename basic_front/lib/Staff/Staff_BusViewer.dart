import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:basic_front/NoteAddition.dart';
import 'package:basic_front/NoteView.dart';
import 'package:basic_front/REST/Get_RetrieveBusInfo.dart';
import 'package:basic_front/REST/Get_RetrieveNotes.dart';
import 'package:basic_front/Structs/Bus.dart';
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

class Staff_BusViewer_Page extends StatefulWidget {
  Staff_BusViewer_Page({Key key, this.user, this.busId}) : super(key: key);

  final User user;
  final String busId;

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
          FutureBuilder(
              future: storage.readToken().then((value) {
                return RetrieveBusInfo(value, widget.busId, context);
              }),
              builder: (BuildContext context, AsyncSnapshot<Bus> snapshot) {
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
                        child: Text("Unable to Fetch Bus Info"),
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text("Name:\n${snapshot.data.driverName}", textAlign: TextAlign.center,
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