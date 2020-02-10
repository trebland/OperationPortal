import 'package:basic_front/BuildPresets/Volunteer_ProfileViewer.dart';
import 'package:flutter/material.dart';


class VolunteerCaptain_VolunteerProfileViewer_Page extends StatefulWidget {
  VolunteerCaptain_VolunteerProfileViewer_Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  VolunteerCaptain_VolunteerProfileViewer_State createState() => VolunteerCaptain_VolunteerProfileViewer_State();
}

class VolunteerCaptain_VolunteerProfileViewer_State extends State<VolunteerCaptain_VolunteerProfileViewer_Page> {

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
          buildPictureNameRow_Volunteer(widget.title),
          buildFirstRowInfo(),
        ],
      ),
    );
  }
}