import 'package:flutter/material.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/AppBar.dart';
import 'package:operationportal/Widget/BusDriverRoster.dart';
import 'package:operationportal/Widget/ChildCheckIn.dart';
import 'package:operationportal/Widget/Suspended.dart';

class BusDriver_ActiveDashboard_Page extends StatefulWidget {
  BusDriver_ActiveDashboard_Page({Key key, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final User user;

  @override
  BusDriver_ActiveDashboard_State createState() => BusDriver_ActiveDashboard_State();
}

class BusDriver_ActiveDashboard_State extends State<BusDriver_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Check-In'),
    Tab(text: 'Roster'),
    Tab(text: 'Suspended'),
  ];

  TabController _tabController;
  Storage storage;

  Widget buildRefreshButton ()
  {
    return IconButton(
      icon: Icon(
        Icons.refresh,
        color: Colors.black,
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
        if (tab.text == "Check-In")
          return ChildCheckInPage(storage: storage,);
        else if(tab.text == "Roster")
          return BusRosterWidgetPage(storage: storage, user: widget.user,);
        else
          return SuspendedWidgetPage(storage: storage, user: widget.user,);
      }).toList(),
    ),
    );
  }
}
















