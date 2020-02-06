import 'package:basic_front/BuildPresets/Child_ProfileViewer.dart';
import 'package:flutter/material.dart';

class VolunteerCaptain_ProfileViewer_Page extends StatefulWidget {
  VolunteerCaptain_ProfileViewer_Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  VolunteerCaptain_ProfileViewer_State createState() => VolunteerCaptain_ProfileViewer_State();
}

class VolunteerCaptain_ProfileViewer_State extends State<VolunteerCaptain_ProfileViewer_Page> {

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
          ],
        ),
    );
  }
}