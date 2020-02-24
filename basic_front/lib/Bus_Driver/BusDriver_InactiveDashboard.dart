import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/BuildPresets/InactiveDashboard.dart';
import 'package:basic_front/Login.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:flutter/material.dart';

class BusDriver_InactiveDashboard_Page extends StatefulWidget {
  BusDriver_InactiveDashboard_Page({Key key, this.profile, this.accessToken}) : super(key: key);

  final Profile profile;
  final String accessToken;

  @override
  BusDriver_InactiveDashboard_State createState() => BusDriver_InactiveDashboard_State();
}

class BusDriver_InactiveDashboard_State extends State<BusDriver_InactiveDashboard_Page>
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildPictureNameRow(widget.profile.firstName, widget.profile.lastName),
            buildQRButton(widget.accessToken, context),
            buildNotice(),
          ],
        ),
      ),
    );
  }
}