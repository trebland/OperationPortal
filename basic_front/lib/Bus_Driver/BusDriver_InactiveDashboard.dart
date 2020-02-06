import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/BuildPresets/InactiveDashboard.dart';
import 'package:basic_front/Login.dart';
import 'package:flutter/material.dart';

class BusDriver_InactiveDashboard_Page extends StatefulWidget {
  BusDriver_InactiveDashboard_Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  BusDriver_InactiveDashboard_State createState() => BusDriver_InactiveDashboard_State();
}

class BusDriver_InactiveDashboard_State extends State<BusDriver_InactiveDashboard_Page>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            buildPictureNameRow("Fake", "Profile"),
            buildQRButton(context, "bd"),
            buildNotice(),
          ],
        ),
      ),
    );
  }
}