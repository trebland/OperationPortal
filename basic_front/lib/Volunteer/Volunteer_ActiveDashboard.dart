import 'dart:convert';

import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/ChildAddition/AddChild.dart';
import 'package:basic_front/REST/Get_RetrieveRoster.dart';
import 'package:basic_front/Structs/Class.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/RosterChild.dart';
import 'package:basic_front/Structs/User.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_ProfileViewer.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    myTabs = new List<Tab>();
    storage = new Storage();
    classIds = new List<String>();

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>
                        [
                          Container(
                            child: IntrinsicHeight(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>
                                  [
                                    Container(
                                      child: Text("Class Id", textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),),
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(20)
                                        ),
                                      ),
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.only(right: 20),
                                    ),
                                    Container(
                                      child: DropdownButton<String>(
                                        value: classIdValue,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.deepPurple
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            classIdValue = newValue;
                                            classIdController.text = newValue;
                                          });
                                        },
                                        items: classIds
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text('$value'),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () => null,
                                        child: Text("Info", style: TextStyle(color: Colors.white)),
                                      ),
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(20)
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(left: 10),
                                    ),
                                  ]
                              ),
                            ),
                            margin: EdgeInsets.all(10),
                          ),
                        ]
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                ),
                Container(
                  child: IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>
                        [
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                filterRosterResults(value);
                              },
                              controller: rosterSearchController,
                              decoration: InputDecoration(
                                  labelText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)))
                              ),
                            ),
                          ),
                          Container(
                              child: FlatButton(
                                  child: Text("Add Child"),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddChildPage(title: 'Add Child')))
                              )
                          )
                        ]
                    ),
                  ),
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                ),
                FutureBuilder(
                    future: storage.readToken().then((value) {
                      return RetrieveRoster(value, "", classIdController.text);
                    }),
                    builder: (BuildContext context, AsyncSnapshot<List<RosterChild>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return new Text('Issue Posting Data');
                        case ConnectionState.waiting:
                          return new Center(child: new CircularProgressIndicator());
                        case ConnectionState.active:
                          return new Text('');
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            children = null;
                            return Center(
                              child: Text("Unable to Fetch Roster (May be an unassigned route!)"),
                            );
                          } else {
                            childrenData = snapshot.data;
                            children = displayChildren.length > 0 ? displayChildren : snapshot.data;
                            return Expanded(
                              child: new ListView.builder(
                                itemCount: children.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: ListTile(
                                      leading: Container(
                                        child: CircleAvatar(
                                          backgroundImage: (children[index].picture != null) ? MemoryImage(base64.decode((children[index].picture))) : null,
                                        ),
                                      ),
                                      title: Text('${children[index].firstName} ' + '${children[index].lastName}',
                                          style: TextStyle(color: Colors.white)),
                                      subtitle: Text('${children[index].birthday != null && children[index].birthday.isNotEmpty ? 'Age: ' + '${calculateBirthday(children[index])}' : 'No Birthday Assigned'}', style: TextStyle(color: Colors.white)),
                                      onTap: ()
                                      {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ProfileViewer_Page(profile: widget.user.profile, child: children[index])));
                                      },
                                      dense: false,
                                    ),
                                    color: Colors.blue[colorCodes[index%2]],
                                  );
                                },
                              ),
                            );
                          }
                          break;
                        default:
                          return null;
                      }
                    }
                ),
              ],
            );
          else if (tab.text == "Inventory Requests")
            return Center(
              child: Container(
                child: Text("Checked-in Successfully! Please speak to leadership about your role assignment.", textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Colors.blue)),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 20, bottom: 5),
              ),
            );
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














