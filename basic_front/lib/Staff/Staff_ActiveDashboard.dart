import 'package:barcode_scan/barcode_scan.dart';
import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/REST/Get_RetrieveRoster.dart';
import 'package:basic_front/REST/Get_RetrieveSuspendedRoster.dart';
import 'package:basic_front/REST/Get_RetrieveUser.dart';
import 'package:basic_front/REST/Post_ConfirmAttendance.dart';
import 'package:basic_front/Staff/Staff_SuspendedProfileViewer.dart';
import 'package:basic_front/Structs/Child.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/SuspendedChild.dart';
import 'package:basic_front/Structs/Volunteer.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import '../ChildAddition/AddChild.dart';
import '../Storage.dart';
import 'Staff_ProfileViewer.dart';

class Staff_ActiveDashboard_Page extends StatefulWidget {
  Staff_ActiveDashboard_Page({Key key, this.profile}) : super(key: key);

  final Profile profile;

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
    Tab(text: 'Dashboard'),
    Tab(text: 'Volunteers'),
    Tab(text: 'Roster'),
    Tab(text: 'Suspended'),
  ];

  void filterSearchResults(String query) {
    if (children == null || childrenData == null)
      return;

    query = query.toUpperCase();

    List<Child> dummySearchList = List<Child>();
    dummySearchList.addAll(childrenData);
    if(query.isNotEmpty) {
      List<Child> dummyListData = List<Child>();
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

  TabController _tabController;
  Storage storage;
  String token;

  List<Child> displayChildren = new List<Child>();
  List<Child> children = new List<Child>();
  List<Child> childrenData = new List<Child>();
  List<SuspendedChild> suspended = new List<SuspendedChild>();

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

  String dropdownValue = 'One';

  bool accessProfileNotes = false;

  void _onAccessProfileNotesChanged(bool newValue) => setState(() {
    accessProfileNotes = newValue;

    if (accessProfileNotes) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });

  bool editProfileNotes = false;

  void _onEditProfileNotesChanged(bool newValue) => setState(() {
    editProfileNotes = newValue;

    if (editProfileNotes) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });

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
        if (tab.text == "Dashboard")
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
                    future: RetrieveUser(barcode, context),
                    builder: (BuildContext context, AsyncSnapshot<Volunteer> snapshot) {
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
                                  child: IntrinsicHeight(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>
                                        [
                                          Container(
                                            child: Text(
                                              "Access Profile Notes",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20, color: Colors.white),
                                            ),
                                          ),
                                          Checkbox(
                                              value: accessProfileNotes,
                                              onChanged: _onAccessProfileNotesChanged
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
                                  child: IntrinsicHeight(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>
                                        [
                                          Container(
                                            child: Text(
                                              "Edit Profile Notes",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20, color: Colors.white),
                                            ),
                                          ),
                                          Checkbox(
                                              value: editProfileNotes,
                                              onChanged: _onEditProfileNotesChanged
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
                                        ConfirmAttendance(token, snapshot.data.profile, context);
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
          return Center(
              child: buildVolunteerList(),
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
                          items: <String>["Select Route", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                        ),
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
                          items: <String>["Select Class", "1", "2", "3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                        ),
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
                            filterSearchResults(value);
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
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
                builder: (BuildContext context, AsyncSnapshot<List<Child>> snapshot) {
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
                                    child: FlutterLogo(size: 56.0),
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(20)
                                      ),
                                    ),
                                  ),
                                  title: Text('${children[index].firstName} ' + '${children[index].lastName}',
                                      style: TextStyle(color: Colors.white)),
                                  onTap: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_ProfileViewer_Page(child: children[index])));
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
                        Container(
                          child: Icon(
                            Icons.search,
                            size: 40,
                          ),
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Flexible(
                          child: TextField(
                            textAlign: TextAlign.left,
                            decoration: new InputDecoration(
                              hintText: 'Search...',
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                            ),
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
                  builder: (BuildContext context, AsyncSnapshot<ReadSuspensions> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new Text('Issue Posting Data');
                      case ConnectionState.waiting:
                        return new Center(child: new CircularProgressIndicator());
                      case ConnectionState.active:
                        return new Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text("Unable to Fetch Roster (May be an unassigned route!)");
                        } else {
                          suspended = snapshot.data.suspended;
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














