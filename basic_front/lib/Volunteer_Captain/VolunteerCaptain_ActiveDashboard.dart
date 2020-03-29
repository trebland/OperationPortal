import 'dart:convert';

import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/ChildAddition/AddChild.dart';
import 'package:basic_front/REST/Get_RetrieveRoster.dart';
import 'package:basic_front/REST/Get_RetrieveVolunteers.dart';
import 'package:basic_front/Staff/Staff_VolunteerProfileViewer.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/RosterChild.dart';
import 'package:basic_front/Structs/User.dart';
import 'package:basic_front/Structs/Volunteer.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_ProfileViewer.dart';
import 'package:flutter/material.dart';

import '../Storage.dart';


class VolunteerCaptain_ActiveDashboard_Page extends StatefulWidget {
  VolunteerCaptain_ActiveDashboard_Page({Key key, this.user}) : super(key: key);

  final User user;

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

  void filterVolunteerResults(String query) {
    if (volunteers == null || volunteerData == null)
      return;

    query = query.toUpperCase();

    List<Volunteer> dummySearchList = List<Volunteer>();
    dummySearchList.addAll(volunteerData);
    if(query.isNotEmpty) {
      List<Volunteer> dummyListData = List<Volunteer>();
      dummySearchList.forEach((item) {
        if(item.firstName.toUpperCase().contains(query) || item.lastName.toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      displayVolunteers.clear();
      displayVolunteers.addAll(dummyListData);
      setState(() {
      });
    } else {
      displayVolunteers.clear();
      setState(() {
      });
    }
  }

  Storage storage;
  String token;

  String barcode;

  String busRouteValue;
  String classIdValue;

  final busRouteController = TextEditingController();
  final classIdController = TextEditingController();

  final rosterSearchController = TextEditingController();
  final volunteerSearchController = TextEditingController();

  List<String> busIds = new List<String>();
  List<String> classIds = new List<String>();

  List<Volunteer> displayVolunteers = new List<Volunteer>();
  List<Volunteer> volunteers = new List<Volunteer>();
  List<Volunteer> volunteerData = new List<Volunteer>();

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
        });
      },
    );
  }

    @override
    void initState() {
      super.initState();
      _tabController = TabController(vsync: this, length: myTabs.length);

      busRouteValue = "Select Route";
      classIdValue = "Select Class";

      busRouteController.text = busRouteValue;
      classIdController.text = classIdValue;

      storage = new Storage();
      storage.readToken().then((value) {
        token = value;
      });
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
                              child: Text("Bus Route", textAlign: TextAlign.center,
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
                                value: busRouteValue,
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
                                    busRouteValue = newValue;
                                    busRouteController.text = newValue;
                                  });
                                },
                                items: busIds
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
                        return RetrieveRoster(value, busRouteController.text, classIdController.text);
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
            else
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                                  filterVolunteerResults(value);
                                },
                                controller: volunteerSearchController,
                                decoration: InputDecoration(
                                    labelText: "Search",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                              ),
                            ),
                          ]
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                  FutureBuilder(
                      future: storage.readToken().then((value) {
                        return RetrieveVolunteers(value, "${DateTime.now().toLocal()}".split(' ')[0]);
                      }),
                      builder: (BuildContext context, AsyncSnapshot<List<Volunteer>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return new Text('Issue Posting Data');
                          case ConnectionState.waiting:
                            return new Center(child: new CircularProgressIndicator());
                          case ConnectionState.active:
                            return new Text('');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              volunteers = null;
                              return Center(
                                child: Text("Unable to Fetch Volunteers"),
                              );
                            } else {
                              volunteerData = snapshot.data;
                              volunteers = displayVolunteers.length > 0 ? displayVolunteers : snapshot.data;
                              return Expanded(
                                child: new ListView.builder(
                                  itemCount: volunteers.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      child: ListTile(
                                        leading: Container(
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage('OCC_LOGO.png'),
                                          ),
                                        ),
                                        title: Text('${volunteers[index].firstName} ' + '${volunteers[index].lastName}',
                                            style: TextStyle(color: Colors.white)),
                                        onTap: ()
                                        {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_VolunteerProfileViewer_Page(volunteer: volunteers[index],)));
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
          }).toList(),
        ),
      );
  }
}














