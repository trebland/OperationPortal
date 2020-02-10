import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:flutter/material.dart';


class VolunteerCaptain_ActiveDashboard_Page extends StatefulWidget {
  VolunteerCaptain_ActiveDashboard_Page({Key key, this.profile}) : super(key: key);

  final Profile profile;

  @override
  VolunteerCaptain_ActiveDashboard_State createState() => VolunteerCaptain_ActiveDashboard_State();
}



class VolunteerCaptain_ActiveDashboard_State extends State<VolunteerCaptain_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{

  final List<Tab> myTabs = <Tab>[
      Tab(text: 'Roster'),
      Tab(text: 'Volunteer List'),
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
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map((Tab tab) {
            if(tab.text == "Roster")
              return Center(
                  child: buildFlexRoster(context),
              );
            else
              return Center(
                  child: buildVolunteerList(),
              );
          }).toList(),
        ),
      );
  }
}














