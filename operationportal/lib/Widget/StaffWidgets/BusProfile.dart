import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Storage.dart';


class BusProfilePage extends StatefulWidget {
  BusProfilePage({Key key, this.bus}) : super(key: key);

  final Bus bus;

  @override
  BusProfileState createState() => BusProfileState();
}

class BusProfileState extends State<BusProfilePage> {
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