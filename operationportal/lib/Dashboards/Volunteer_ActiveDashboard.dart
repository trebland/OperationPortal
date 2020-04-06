import 'package:flutter/material.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/AppBar.dart';
import 'package:operationportal/Widget/Inventory.dart';
import 'package:operationportal/Widget/TeacherRoster.dart';


class Volunteer_ActiveDashboard_Page extends StatefulWidget {
  Volunteer_ActiveDashboard_Page({Key key, this.user}) : super(key: key);


  final User user;

  @override
  Volunteer_ActiveDashboard_State createState() => Volunteer_ActiveDashboard_State();
}

class Volunteer_ActiveDashboard_State extends State<Volunteer_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{

  List<Tab> myTabs;

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
    myTabs = new List<Tab>();
    storage = new Storage();

    if (widget.user.isTeacher)
      myTabs.add(Tab(text: "Roster"));
    if (widget.user.profile.canEditInventory)
      myTabs.add(Tab(text: "Inventory Requests"));
    if (!widget.user.isTeacher && !widget.user.profile.canEditInventory)
      myTabs.add(Tab(text: "Welcome"));


    _tabController = TabController(vsync: this, length: myTabs.length);

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
          if(tab.text == "Roster")
            return TeacherRosterWidgetPage(storage: storage, user: widget.user);
          else if (tab.text == "Inventory Requests")
            return InventoryWidgetPage(storage: storage,);
          else
            return Center(
              child: Container(
                child: Text("Checked-in Successfully! Please speak to leadership about your role assignment.", textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Colors.blue)),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 20, bottom: 5),
              ),
            );
        }).toList(),
      ),
    );
  }
}














