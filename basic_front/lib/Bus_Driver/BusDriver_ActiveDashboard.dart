import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/ChildAddition/AddChild.dart';
import 'package:basic_front/REST/Get_RetrieveBuses.dart';
import 'package:basic_front/REST/Get_RetrieveChild.dart';
import 'package:basic_front/REST/Get_RetrieveClasses.dart';
import 'package:basic_front/REST/Get_RetrieveRoster.dart';
import 'package:basic_front/REST/Get_RetrieveSuspendedRoster.dart';
import 'package:basic_front/REST/Get_RetrieveUser.dart';
import 'package:basic_front/REST/Post_ConfirmChildAttendance.dart';
import 'package:basic_front/REST/Post_ConfirmVolunteerAttendance.dart';
import 'package:basic_front/Staff/Staff_ProfileViewer.dart';
import 'package:basic_front/Staff/Staff_SuspendedProfileViewer.dart';
import 'package:basic_front/Structs/Bus.dart';
import 'package:basic_front/Structs/Child.dart';
import 'package:basic_front/Structs/RosterChild.dart';
import 'package:basic_front/Structs/Class.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/SuspendedChild.dart';
import 'package:basic_front/Structs/User.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_ProfileViewer.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import '../Storage.dart';

class BusDriver_ActiveDashboard_Page extends StatefulWidget {
  BusDriver_ActiveDashboard_Page({Key key, this.profile}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Profile profile;

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

  final List<int> colorCodes = <int>[600, 500];

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

  void filterSuspendedResults(String query) {
    if (suspended == null || suspendedData == null)
      return;

    query = query.toUpperCase();

    List<SuspendedChild> dummySearchList = List<SuspendedChild>();
    dummySearchList.addAll(suspendedData);
    if(query.isNotEmpty) {
      List<SuspendedChild> dummyListData = List<SuspendedChild>();
      dummySearchList.forEach((item) {
        if(item.firstName.toUpperCase().contains(query) || item.lastName.toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      displaySuspended.clear();
      displaySuspended.addAll(dummyListData);
      setState(() {
      });
    } else {
      displaySuspended.clear();
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
  final suspendedSearchController = TextEditingController();

  List<String> busIds = new List<String>();
  List<String> classIds = new List<String>();

  List<RosterChild> displayChildren = new List<RosterChild>();
  List<RosterChild> children = new List<RosterChild>();
  List<RosterChild> childrenData = new List<RosterChild>();

  List<SuspendedChild> displaySuspended = new List<SuspendedChild>();
  List<SuspendedChild> suspended = new List<SuspendedChild>();
  List<SuspendedChild> suspendedData = new List<SuspendedChild>();

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

    busRouteValue = "3";
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
        if (tab.text == "Check-In")
          {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>
                          [
                            Flexible(
                              child: Text("Recent Child", style: TextStyle(fontSize: 30, color: Colors.white),),
                            ),
                            Container(
                              child: FlatButton(
                                child: Text("Scan QR", style: TextStyle(color: Colors.black),),
                                onPressed: () => scan(),
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20)
                                ),
                              ),
                              margin: EdgeInsets.only(left: 20),
                            ),
                          ]
                      ),
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(20)
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                  ),
                  FutureBuilder(
                      future: RetrieveChild(token, barcode, context),
                      builder: (BuildContext context, AsyncSnapshot<Child> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return new Text('Issue Posting Data');
                          case ConnectionState.waiting:
                            return new Center(child: new CircularProgressIndicator());
                          case ConnectionState.active:
                            return new Text('');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text("Press 'Scan QR' to begin!");
                            } else {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    child: IntrinsicHeight(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>
                                          [
                                            Container(
                                              child: CircleAvatar(
                                                backgroundImage: (snapshot.data.picture != null) ? MemoryImage(base64.decode((snapshot.data.picture))) : null,
                                              ),
                                              height: 200,
                                              width: 200,
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(right: 10),
                                            ),
                                            Flexible(
                                              child: Text(
                                                snapshot.data.firstName + "\n" + snapshot.data.lastName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 28, color: Colors.white),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(20)
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                  ),
                                  Container(
                                      child: FlatButton(
                                        child: Text("Confirm Attendance", style: TextStyle(fontSize: 20, color: Colors.white),),
                                        onPressed: () {
                                          ConfirmChildAttendance(token, snapshot.data, context);
                                        },
                                      ),
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(20)
                                        ),
                                      ),
                                      margin: EdgeInsets.only(top: 20)
                                  ),
                                ],
                              );
                            }
                            break;
                          default:
                            return null;
                        }
                      }
                  ),
                ],
              ),
            );
          }
        else if(tab.text == "Roster")
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
                          child: Text("Bus Route #$busRouteValue", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, color: Colors.white),),
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(20)
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(right: 20),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ProfileViewer_Page(profile: widget.profile, child: children[index])));
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
                              filterSuspendedResults(value);
                            },
                            controller: rosterSearchController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                labelText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ]
                  ),
                ),
                margin: EdgeInsets.all(10),
              ),
              FutureBuilder(
                  future: storage.readToken().then((value) {
                    return GetSuspendedChildren(value);
                  }),
                  builder: (BuildContext context, AsyncSnapshot<List<SuspendedChild>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new Text('Issue Posting Data');
                      case ConnectionState.waiting:
                        return new Center(child: new CircularProgressIndicator());
                      case ConnectionState.active:
                        return new Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          suspended = null;
                          return Center(
                            child: Text("Unable to Fetch Roster (May be an unassigned route!)"),
                          );
                        } else {
                          suspendedData = snapshot.data;
                          suspended = displaySuspended.length > 0 ? displaySuspended : snapshot.data;
                          return Expanded(
                            child: new ListView.builder(
                              itemCount: suspended.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: ListTile(
                                    title: Text('${suspended[index].firstName} ' + '${suspended[index].lastName}',
                                        style: TextStyle(color: Colors.white)),
                                    onTap: ()
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_SuspendedProfileViewer_Page(child: suspended[index])));
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
















