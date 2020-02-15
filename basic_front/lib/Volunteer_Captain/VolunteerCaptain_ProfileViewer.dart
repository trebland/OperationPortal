import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:flutter/material.dart';

class VolunteerCaptain_ProfileViewer_Page extends StatefulWidget {
  VolunteerCaptain_ProfileViewer_Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  VolunteerCaptain_ProfileViewer_State createState() => VolunteerCaptain_ProfileViewer_State();
}

class VolunteerCaptain_ProfileViewer_State extends State<VolunteerCaptain_ProfileViewer_Page> {

  final suspensionController = TextEditingController();
  bool isSuspended = false;

  String checkSuspension ()
  {
    return isSuspended ? "Suspended" : "Not Suspended";
  }

  @override
  void initState() {
    suspensionController.text = checkSuspension();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPictureNameRow_Child(widget.title),
            buildBirthdayAndGradeRow(),
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
          ],
        ),
    );
  }
}