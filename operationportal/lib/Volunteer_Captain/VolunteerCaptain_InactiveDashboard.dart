import 'package:operationportal/BuildPresets/AppBar.dart';
import 'package:operationportal/BuildPresets/InactiveDashboard.dart';
import 'package:operationportal/Login.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:flutter/material.dart';

class VolunteerCaptain_InactiveDashboard_Page extends StatefulWidget {
  VolunteerCaptain_InactiveDashboard_Page({Key key, this.profile, this.accessToken}) : super(key: key);

  Profile profile;
  final String accessToken;

  @override
  VolunteerCaptain_InactiveDashboard_State createState() => VolunteerCaptain_InactiveDashboard_State();
}

class VolunteerCaptain_InactiveDashboard_State extends State<VolunteerCaptain_InactiveDashboard_Page>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          buildLogoutButton(context),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildPictureNameRow(widget.profile.firstName, widget.profile.lastName),
            buildQRButton(widget.accessToken, context),
            buildNotice(),
          ],
        ),
    );
  }
}