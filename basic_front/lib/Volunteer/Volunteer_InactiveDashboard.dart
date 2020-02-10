import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/BuildPresets/InactiveDashboard.dart';
import 'package:basic_front/Login.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:flutter/material.dart';

class Volunteer_InactiveDashboard_Page extends StatefulWidget {
  Volunteer_InactiveDashboard_Page({Key key, this.profile}) : super(key: key);

  final Profile profile;

  @override
  Volunteer_InactiveDashboard_State createState() => Volunteer_InactiveDashboard_State();
}

class Volunteer_InactiveDashboard_State extends State<Volunteer_InactiveDashboard_Page>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile.role),
        actions: <Widget>[
          buildLogoutButton(context),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildPictureNameRow(widget.profile.firstName, widget.profile.lastName),
            buildQRButton(context),
            buildNotice(),
          ],
        ),
      ),
    );
  }
}