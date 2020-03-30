import 'package:operationportal/BuildPresets/Volunteer_ProfileViewer.dart';
import 'package:operationportal/Structs/Volunteer.dart';
import 'package:flutter/material.dart';

class Staff_VolunteerProfileViewer_Page extends StatefulWidget {
  Staff_VolunteerProfileViewer_Page({Key key, this.volunteer}) : super(key: key);

  final Volunteer volunteer;

  @override
  Staff_VolunteerProfileViewer_State createState() => Staff_VolunteerProfileViewer_State();
}

class Staff_VolunteerProfileViewer_State extends State<Staff_VolunteerProfileViewer_Page> {

  List<String> notes = ["Doesn't play well with Henry", "Loves Juice", "Dislikes Soccer", "Likes Monopoly"];

  final List<int> colorCodes = <int>[600, 500];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildPictureNameRow_Volunteer(widget.volunteer.firstName + " " + widget.volunteer.lastName),
          buildFirstRowInfo(),
        ],
      ),
    );
  }
}