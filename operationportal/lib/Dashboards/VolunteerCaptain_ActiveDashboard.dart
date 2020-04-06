import 'package:flutter/material.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/AppBar.dart';
import 'package:operationportal/Widget/Volunteer.dart';

class VolunteerCaptain_ActiveDashboard_Page extends StatefulWidget {
  VolunteerCaptain_ActiveDashboard_Page({Key key, this.user}) : super(key: key);

  final User user;

  @override
  VolunteerCaptain_ActiveDashboard_State createState() => VolunteerCaptain_ActiveDashboard_State();
}



class VolunteerCaptain_ActiveDashboard_State extends State<VolunteerCaptain_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{
  final List<Tab> myTabs = <Tab>[
      Tab(text: 'Volunteer List'),
    ];

  TabController _tabController;

  Storage storage;

  Widget buildRefreshButton ()
  {
    return IconButton(
      icon: Icon(
        Icons.refresh,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
        });
      },
    );
  }

    @override
    void initState() {
      _tabController = TabController(vsync: this, length: myTabs.length);
      storage = new Storage();

      super.initState();
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
            buildRefreshButton(),
            buildProfileButton(context, widget.user.profile),
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
            if(tab.text == "Volunteer List")
              return VolunteerWidgetPage(storage: storage,);
            else
              return Container();
          }).toList(),
        ),
      );
  }
}














