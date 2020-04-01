import 'dart:convert';

import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:flutter/material.dart';

import '../Structs/Storage.dart';

class SemiChildProfilePage extends StatefulWidget {
  SemiChildProfilePage({Key key, this.profile, this.child}) : super(key: key);

  final Profile profile;
  final RosterChild child;

  @override
  SemiChildProfileState createState() => SemiChildProfileState();
}

class SemiChildProfileState extends State<SemiChildProfilePage> {
  final suspensionController = TextEditingController();

  Storage storage;

  final List<int> colorCodes = <int>[600, 500];

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
                    Flexible(
                      child: TextField(
                        textAlign: TextAlign.left,
                        controller: suspensionController,
                        decoration: new InputDecoration(
                          labelText: "Suspension Status",
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
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
        ],
      ),
    );
  }

}