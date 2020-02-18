import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Storage.dart';
import 'Structs/Child.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'Structs/SuspendedChild.dart';

class SuspendResponse {
  List<SuspendedChild> suspended;

  SuspendResponse({this.suspended});

  factory SuspendResponse.fromJson(Map<String, dynamic> json) {
    return SuspendResponse(
      suspended: json['suspensions'].map<SuspendedChild>((value) => new SuspendedChild.fromJson(value)).toList(),
    );
  }
}

Future<void> SuspendChild (String token, int id, String start, String end, BuildContext context)
async {
  var mUrl = "https://www.operation-portal.com/api/suspend";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var body = json.encode({
    'id': id,
    'start': start,
    'end': end,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: headers);

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: 'Child Suspended',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.pop(context);
  } else {

    return null;
  }
}

class SuspensionScreen extends StatefulWidget {
  SuspensionScreen({Key key, this.child}) : super(key: key);

  Child child;

  @override
  SuspensionState createState() => new SuspensionState();
}

class SuspensionState extends State<SuspensionScreen> {

  final startTime = new TextEditingController();
  final endTime = new TextEditingController();

  DateTime currentDate;
  DateTime startDate;
  DateTime endDate;

  int futureYears;

  Storage storage;

  @override
  initState() {
    super.initState();

    storage = new Storage();

    DateTime tempTime = DateTime.now();
    currentDate = DateTime(tempTime.year, tempTime.month, tempTime.day);
    startDate = DateTime.now();

    futureYears = tempTime.year + 25;
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: DateTime(futureYears, 12, 31));
    if (picked != null) {
      setState(() {
        startDate = picked;
      });
      startTime.text = "${startDate.toLocal()}".split(' ')[0];
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(futureYears, 12, 31));
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
      endTime.text = "${endDate.toLocal()}".split(' ')[0];
    }
  }

  Widget buildStartSuspensionColumn ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.calendar_view_day,
                      size: 40,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: startTime,
                      decoration: new InputDecoration(
                        labelText: "Start of Suspension",
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
          margin: EdgeInsets.only(top: 25, left: 25, right: 25,),
        ),
        Container(
          child: OutlineButton(
            onPressed: () => _selectStartDate(context),
            child: Text('Select Start of Suspension'),
          ),
        ),
      ],
    );
  }

  Widget buildEndSuspensionColumn ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.calendar_view_day,
                      size: 40,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: endTime,
                      decoration: new InputDecoration(
                        labelText: "End of Suspension",
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
          margin: EdgeInsets.only(top: 25, left: 25, right: 25,),
        ),
        Container(
          child: OutlineButton(
            onPressed: () => _selectEndDate(context),
            child: Text('Select End of Suspension'),
          ),
        ),
      ],
    );
  }

  Widget buildConfirmSuspensionButton(int id, String start, String end)
  {
    return RaisedButton(
      child: Text('Confirm Suspension'),
      onPressed: () {
        storage.readToken().then((value) {
          SuspendChild(value, id, start, end, context);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        AppBar appBar = AppBar(
          title: Text("Register Account"),
        );
        return Scaffold (
          appBar: appBar,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - appBar.preferredSize.height*2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildStartSuspensionColumn(),
                            buildEndSuspensionColumn(),
                          ],
                        )
                    ),
                    buildConfirmSuspensionButton(widget.child.id, startTime.text, endTime.text),
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