import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:flutter/material.dart';

class Volunteer_ActiveDashboard_Page extends StatefulWidget {
  Volunteer_ActiveDashboard_Page({Key key, this.profile}) : super(key: key);


  final Profile profile;

  @override
  Volunteer_ActiveDashboard_State createState() => Volunteer_ActiveDashboard_State();
}

class Volunteer_ActiveDashboard_State extends State<Volunteer_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Roster')
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          buildProfileButton(context, widget.profile),
          buildLogoutButton(context),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Container(
          child: Text("Checked-in Successfully! Please speak to leadership about your role assignment.", textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, color: Colors.blue)),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(top: 20, bottom: 5),
        ),
      )
    );
  }
}














