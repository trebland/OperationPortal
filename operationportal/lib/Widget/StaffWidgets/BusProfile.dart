import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
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

  Widget buildPictureNameRow ()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                  child: CircleAvatar(
                    backgroundImage: (widget.bus.driverPicture != null && bus.driverPicture.isNotEmpty) ? MemoryImage(base64.decode((widget.bus.driverPicture))) : null,
                  ),
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.only(top: 10, right: 20)
              ),
              Flexible(
                child: Text(
                  widget.bus.driverName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.all(10),
    );
  }

  Widget buildAdditionalInfo()
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
                          "Bus Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          widget.bus.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Bus Route",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          widget.bus.route,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
/*
                      "lastOilChange": DateTime,
                      "lastTireChange": DateTime,
                      "lastMaintenance": DateTime*/
                      Container(
                        child: Text(
                          "Last Oil Change",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          formatDate(widget.bus.lastOilChange.toString()),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Last Tire Change",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          formatDate(widget.bus.lastTireChange.toString()),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Last Maintenance",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          formatDate(widget.bus.lastMaintenance.toString()),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  )
              ),
            ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        AppBar appBar = AppBar(
          title: Text("Bus Info"),
        );
        return Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    buildPictureNameRow(),
                    buildAdditionalInfo(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}