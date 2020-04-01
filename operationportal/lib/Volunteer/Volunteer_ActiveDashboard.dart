import 'dart:convert';

import 'package:operationportal/BuildPresets/ActiveDashboard.dart';
import 'package:operationportal/BuildPresets/AppBar.dart';
import 'package:operationportal/ChildAddition/AddChild.dart';
import 'package:operationportal/REST/Get_RetrieveRoster.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Volunteer_Captain/VolunteerCaptain_ProfileViewer.dart';
import 'package:flutter/material.dart';
import 'package:operationportal/Widget/TeacherRoster.dart';
import 'package:operationportal/Widget/Inventory.dart';

import '../Storage.dart';

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

  void filterRosterResults(String query) {
    if (children == null || childrenData == null)
      return;

    query = query.toUpperCase();

    List<RosterChild> dummySearchList = List<RosterChild>();
    dummySearchList.addAll(childrenData);
    if(query.isNotEmpty) {
      List<RosterChild> dummyListData = List<RosterChild>();
      dummySearchList.forEach((item) {
        if(item.firstName.toUpperCase().contains(query) || item.lastName.toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      displayChildren.clear();
      displayChildren.addAll(dummyListData);
      setState(() {
      });
    } else {
      displayChildren.clear();
      setState(() {
      });
    }
  }

  String busRouteValue;
  String classIdValue;
  List<String> classIds;

  final classIdController = TextEditingController();

  final rosterSearchController = TextEditingController();

  List<RosterChild> displayChildren = new List<RosterChild>();
  List<RosterChild> children = new List<RosterChild>();
  List<RosterChild> childrenData = new List<RosterChild>();

  DateTime parseBirthday (String birthday)
  {
    List<String> dateBreak = new List<String>();
    dateBreak = birthday.split('/');
    return DateTime(int.parse(dateBreak[2]), int.parse(dateBreak[0]), int.parse(dateBreak[1]));
  }

  int calculateBirthday(RosterChild child)
  {
    return DateTime.now().difference(parseBirthday(child.birthday.split(' ')[0])).inDays ~/ 365.25;
  }

  Widget buildRefreshButton ()
  {
    return IconButton(
      icon: Icon(
        Icons.refresh,
        color: Colors.black,
      ),
      onPressed: () {
        setState(() {
          checkClasses();
        });
      },
    );
  }

  void checkClasses ()
  {
    List<String> tempList = new List<String>();
    tempList.add("Select Class");
    for (Class c in widget.user.classes)
      {
        print('${c.id}');
        tempList.add('${c.id}');
      }
    classIds = tempList;
  }

  bool filterCheckedIn;

  List<RosterChild> FilterChildren (List<RosterChild> children)
  {
    List<RosterChild> newList = new List<RosterChild>();
    for (RosterChild c in children)
    {
      if (c.isCheckedIn)
        newList.add(c);
    }

    return newList;
  }

  @override
  void initState() {
    super.initState();

    myTabs = new List<Tab>();
    storage = new Storage();
    classIds = new List<String>();

    filterCheckedIn = false;

    if (widget.user.isTeacher)
      myTabs.add(Tab(text: "Roster"));
    if (widget.user.profile.canEditInventory)
      myTabs.add(Tab(text: "Inventory Requests"));
    if (!widget.user.isTeacher && !widget.user.profile.canEditInventory)
      myTabs.add(Tab(text: "Welcome"));


    _tabController = TabController(vsync: this, length: myTabs.length);
    checkClasses();
    classIdValue = "Select Class";
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














