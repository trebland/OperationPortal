
import 'package:flutter/material.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/AppBar.dart';
import 'package:operationportal/Widget/ChildCheckIn.dart';
import 'package:operationportal/Widget/Inventory.dart';
import 'package:operationportal/Widget/StaffWidgets/Roster.dart';
import 'package:operationportal/Widget/StaffWidgets/VolunteerCheckIn.dart';
import 'package:operationportal/Widget/Suspended.dart';
import 'package:operationportal/Widget/Volunteer.dart';

class Staff_ActiveDashboard_Page extends StatefulWidget {
  Staff_ActiveDashboard_Page({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Staff_ActiveDashboard_State createState() => Staff_ActiveDashboard_State();
}

class Staff_ActiveDashboard_State extends State<Staff_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Volunteer Check-In'),
    Tab(text: 'Child Check-In'),
    Tab(text: 'Volunteers'),
    Tab(text: 'Roster'),
    Tab(text: 'Suspended'),
    Tab(text: 'Inventory Request'),
  ];

  TabController _tabController;
  Storage storage;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Image.asset('assets/OCC_BUS_T.png'),
          width: 150,
        ),
        actions: <Widget>[
          buildRefreshButton(),
          buildProfileButton(context, widget.user.profile),
          buildLogoutButton(context),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: myTabs,
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          if (tab.text == "Volunteer Check-In")
            return VolunteerCheckInPage(storage: storage,);
          else if (tab.text == "Child Check-In")
            return ChildCheckInPage(storage: storage,);
          else if(tab.text == "Volunteers")
            return VolunteerWidgetPage(storage: storage,);
          else if(tab.text == "Roster")
            return RosterWidgetPage(storage: storage, user: widget.user, futureBuses: null, futureClasses: null,);
          else if(tab.text == "Suspended")
            return SuspendedWidgetPage(storage: storage, user: widget.user);
          else
            return InventoryWidgetPage(storage: storage,);
        }).toList(),
      ),
    );
  }
}














