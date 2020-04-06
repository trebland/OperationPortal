
import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/Storage.dart';

class ClassProfilePage extends StatefulWidget {
  ClassProfilePage({Key key, this.mClass}) : super(key: key);

  final Class mClass;

  @override
  ClassProfileState createState() => ClassProfileState();
}

class ClassProfileState extends State<ClassProfilePage> {

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
                      color: primaryWidgetColor,
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