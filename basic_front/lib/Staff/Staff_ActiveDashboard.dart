import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/ItemAddition.dart';
import 'package:basic_front/ItemView.dart';
import 'package:basic_front/REST/Get_RetrieveBuses.dart';
import 'package:basic_front/REST/Get_RetrieveClasses.dart';
import 'package:basic_front/REST/Get_RetrieveInventory.dart';
import 'package:basic_front/REST/Get_RetrieveRoster.dart';
import 'package:basic_front/REST/Get_RetrieveSuspendedRoster.dart';
import 'package:basic_front/REST/Get_RetrieveUser.dart';
import 'package:basic_front/REST/Get_RetrieveVolunteers.dart';
import 'package:basic_front/REST/Post_ConfirmVolunteerAttendance.dart';
import 'package:basic_front/Staff/Staff_BusViewer.dart';
import 'package:basic_front/Staff/Staff_ClassViewer.dart';
import 'package:basic_front/Staff/Staff_SuspendedProfileViewer.dart';
import 'package:basic_front/Staff/Staff_VolunteerProfileViewer.dart';
import 'package:basic_front/Structs/Bus.dart';
import 'package:basic_front/Structs/RosterChild.dart';
import 'package:basic_front/Structs/Class.dart';
import 'package:basic_front/Structs/Item.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/SuspendedChild.dart';
import 'package:basic_front/Structs/User.dart';
import 'package:basic_front/Structs/Volunteer.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import '../ChildAddition/AddChild.dart';
import '../Storage.dart';
import 'Staff_ProfileViewer.dart';

class Staff_ActiveDashboard_Page extends StatefulWidget {
  Staff_ActiveDashboard_Page({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Staff_ActiveDashboard_State createState() => Staff_ActiveDashboard_State();
}

class Staff_ActiveDashboard_State extends State<Staff_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{
  String barcode = "";

  String busRouteValue;
  String classIdValue;

  final busRouteController = TextEditingController();
  final classIdController = TextEditingController();
  final searchController = TextEditingController();

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Check-In'),
    Tab(text: 'Volunteers'),
    Tab(text: 'Roster'),
    Tab(text: 'Suspended'),
    Tab(text: 'Inventory Request'),
  ];

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

    List<RosterChild> dummySearchList = List<RosterChild>();
    dummySearchList.addAll(suspendedData);
    if(query.isNotEmpty) {
      List<RosterChild> dummyListData = List<RosterChild>();
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

  void filterInventoryResults(String query) {
    if (items == null || itemData == null)
      return;

    query = query.toUpperCase();

    List<Item> dummySearchList = List<Item>();
    dummySearchList.addAll(itemData);
    if(query.isNotEmpty) {
      List<Item> dummyListData = List<Item>();
      dummySearchList.forEach((item) {
        if(item.name.toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      displayItems.clear();
      displayItems.addAll(dummyListData);
      setState(() {
      });
    } else {
      displayItems.clear();
      setState(() {
      });
    }
  }

  TabController _tabController;
  Storage storage;
  String token;

  bool filterCheckedIn;

  List<String> busIds = new List<String>();
  List<String> classIds = new List<String>();

  List<Volunteer> displayVolunteers = new List<Volunteer>();
  List<Volunteer> volunteers = new List<Volunteer>();
  List<Volunteer> volunteerData = new List<Volunteer>();

  List<RosterChild> displayChildren = new List<RosterChild>();
  List<RosterChild> children = new List<RosterChild>();
  List<RosterChild> childrenData = new List<RosterChild>();

  List<RosterChild> displaySuspended = new List<RosterChild>();
  List<RosterChild> suspended = new List<RosterChild>();
  List<RosterChild> suspendedData = new List<RosterChild>();

  List<Item> displayItems = new List<Item>();
  List<Item> items = new List<Item>();
  List<Item> itemData = new List<Item>();

  void call_GetRetrieveBuses ()
  {
    List<String> tempList = new List<String>();
    tempList.add("Select Route");
    storage.readToken().then((value){
      RetrieveBuses(value).then((value) {
        for(Bus b in value)
          tempList.add('${b.id}');

        setState(() {
          busIds = tempList;
        });
      });
    });
  }

  void call_GetRetrieveClasses ()
  {
    List<String> tempList = new List<String>();
    tempList.add("Select Class");
    storage.readToken().then((value){
      RetrieveClasses(value).then((value) {
        for(Class c in value)
          tempList.add('${c.id}');

        setState(() {
          classIds = tempList;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);

    busRouteValue = "Select Route";
    classIdValue = "Select Class";
    filterCheckedIn = false;

    busRouteController.text = busRouteValue;
    classIdController.text = classIdValue;

    storage = new Storage();
    storage.readToken().then((value) {
      token = value;
    });

    call_GetRetrieveBuses();
    call_GetRetrieveClasses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String dropdownValue = 'One';

  Widget buildRefreshButton ()
  {
     return IconButton(
       icon: Icon(
         Icons.refresh,
         color: Colors.black,
       ),
       onPressed: () {
         setState(() {
           call_GetRetrieveBuses();
           call_GetRetrieveClasses();
         });
       },
     );
  }

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
          isScrollable: true,
          tabs: myTabs,
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: TabBarView(
      controller: _tabController,
      children: myTabs.map((Tab tab) {
        if (tab.text == "Check-In")
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
                            child: Text("Recent Volunteer", style: TextStyle(fontSize: 30, color: Colors.white),),
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
                    future: barcode.isNotEmpty ? RetrieveUser(barcode, context) : null,
                    builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
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
                                            child: Image(
                                                image: AssetImage('assets/OCC_LOGO_128_128.png')
                                            ),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: new BorderRadius.all(
                                                  new Radius.circular(20)
                                              ),
                                            ),
                                            height: 200,
                                            width: 200,
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshot.data.profile.firstName + "\n" + snapshot.data.profile.lastName,
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
                                      child: Text("Confirm Assignment", style: TextStyle(fontSize: 20, color: Colors.white),),
                                      onPressed: () {
                                        ConfirmVolunteerAttendance(token, snapshot.data.profile, context);
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
        else if(tab.text == "Volunteers")
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
                            controller: searchController,
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
                          onPressed: () {
                            if(busRouteValue != "Select Route")
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_BusViewer_Page(busId: busRouteValue,)));
                          },
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
                          onPressed: () {
                            if (classIdValue != "Select Class")
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_ClassViewer_Page(classId: classIdValue,)));
                          },
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
              child: CheckboxListTile(
                title: const Text('Filter Checked In'),
                value: filterCheckedIn,
                onChanged: (bool value) {
                  setState(() { filterCheckedIn = !filterCheckedIn; });
                },
                secondary: const Icon(Icons.filter_tilt_shift),
              ),
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
                          controller: searchController,
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
                        children = displayChildren.length > 0 ? displayChildren : childrenData;
                        filterCheckedIn ? children = FilterChildren(children) : children;
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_ProfileViewer_Page(user: widget.user, child: children[index])));
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
        else if(tab.text == "Suspended")
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
                          suspended = null;
                          return Center(
                            child: Text("No Suspended Students/Issues Connecting"),
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
                                    leading: Container(
                                      child: CircleAvatar(
                                        backgroundImage: (suspended[index].picture != null) ? MemoryImage(base64.decode((suspended[index].picture))) : null,
                                      ),
                                    ),
                                    title: Text('${suspended[index].firstName} ' + '${suspended[index].lastName}',
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text('${suspended[index].startSuspension != null && suspended[index].endSuspension != null ? 'Start of Suspension: ' + '${suspended[index].startSuspension.split('T')[0]}' + '\n' + 'End of Suspension: ' + '${suspended[index].endSuspension.split('T')[0]}' : 'No Suspension Information'}', style: TextStyle(color: Colors.white)),
                                    onTap: ()
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_ProfileViewer_Page(user: widget.user, child: suspended[index])));
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
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                labelText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                            child: FlatButton(
                                child: Text("Add Item"),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemAdditionPage()))
                            )
                        ),
                      ]
                  ),
                ),
                margin: EdgeInsets.all(10),
              ),
              FutureBuilder(
                  future: storage.readToken().then((value) {
                    return RetrieveInventory(value);
                  }),
                  builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new Text('Issue Posting Data');
                      case ConnectionState.waiting:
                        return new Center(child: new CircularProgressIndicator());
                      case ConnectionState.active:
                        return new Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          items = null;
                          return Center(
                            child: Text("Unable to Fetch Inventory"),
                          );
                        } else {
                          itemData = snapshot.data;
                          items = displayItems.length > 0 ? displayItems : snapshot.data;
                          return Expanded(
                            child: new ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: ListTile(
                                    title: Text('${items[index].name}',
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text('Count: ' + '${items[index].count}',
                                        style: TextStyle(color: Colors.white)),
                                    onTap: ()
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemViewPage(item: items[index],)));
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














