import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/REST/LoginCalls.dart';
import 'package:basic_front/ScanQR.dart';
import 'package:basic_front/Structs/Child.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Structs/SuspendedChild.dart';
import 'package:basic_front/Structs/Volunteer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../AddChild.dart';
import '../Storage.dart';
import 'Staff_ProfileViewer.dart';

class Confirm_Success {
  DateTime daysAttended;

  Confirm_Success({this.daysAttended});

  factory Confirm_Success.fromJson(Map<String, dynamic> json) {
    return Confirm_Success(
      daysAttended: json['DaysAttended'],
    );
  }
}

class Confirm_Failure {
  String error;

  Confirm_Failure({this.error});

  factory Confirm_Failure.fromJson(Map<String, dynamic> json) {
    return Confirm_Failure(
      error: json['error'],
    );
  }
}

Future<void> ConfirmAttendance (String token, Profile toConfirm, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/volunteer-attendance-check";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/json', 'Authorization': 'Bearer ' + token, 'id': '${toConfirm.id}'});

  if (response.statusCode == 200) {

    Confirm_Success mPost = Confirm_Success.fromJson(json.decode(response.body));

    // If the call to the server was successful, parse the JSON.
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

  } else {

    Confirm_Failure mPost = Confirm_Failure.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    throw Exception('Failed to load post');
  }
}

class ReadChildren {

  List<Child> children;

  ReadChildren({this.children});

  factory ReadChildren.fromJson(Map<String, dynamic> json) {
    return ReadChildren(
      children: json['busRoster'].map<Child>((value) => new Child.fromJson(value)).toList(),
    );
  }
}

Future<ReadChildren> GetRoster (String token, int busId) async {
  var mUrl = "https://www.operation-portal.com/api/roster?busId=1";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var queryParameters = {
    'busId': '$busId',
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadChildren mPost = ReadChildren.fromJson(json.decode(response.body));

    return mPost;

  } else {

    return null;
  }
}

class ReadVolunteers {
  List<Volunteer> volunteers;

  ReadVolunteers({this.volunteers});

  factory ReadVolunteers.fromJson(Map<String, dynamic> json) {
  return ReadVolunteers(
    volunteers: json['busRoster'].map<Child>((value) => new Child.fromJson(value)).toList(),
  );
  }
}

Future<ReadVolunteers> GetVolunteers (String token, DateTime currentDay)
{

}

class ReadSuspensions {
  List<SuspendedChild> suspended;

  ReadSuspensions({this.suspended});

  factory ReadSuspensions.fromJson(Map<String, dynamic> json) {
    return ReadSuspensions(
      suspended: json['suspensions'].map<SuspendedChild>((value) => new SuspendedChild.fromJson(value)).toList(),
    );
  }
}

Future<ReadSuspensions> GetSuspendedChildren (String token)
async {
  var mUrl = "https://www.operation-portal.com/api/suspensions";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadSuspensions mGet = ReadSuspensions.fromJson(json.decode(response.body));

    return mGet;

  } else {

    return null;
  }
}

class Staff_ActiveDashboard_Page extends StatefulWidget {
  Staff_ActiveDashboard_Page({Key key, this.profile}) : super(key: key);

  final Profile profile;

  @override
  Staff_ActiveDashboard_State createState() => Staff_ActiveDashboard_State();
}

class Staff_ActiveDashboard_State extends State<Staff_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{
  String barcode = "";

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Dashboard'),
    Tab(text: 'Volunteers'),
    Tab(text: 'Roster'),
    Tab(text: 'Suspended'),
  ];

  TabController _tabController;
  Storage storage;
  String token;

  List<Child> children = new List<Child>();
  List<SuspendedChild> suspended = new List<SuspendedChild>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);

    storage = new Storage();
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
                    builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
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
                                      onPressed: () => ConfirmAttendance(token, snapshot.data, context),
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
                        child: Text("Bus Route #3", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, color: Colors.white),),
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                      Flexible(
                          child: FlatButton(
                            child: Text("Change Route"),
                            onPressed: () => null,
                          )
                      )
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
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
                  return GetRoster(value,1);
                }),
                builder: (BuildContext context, AsyncSnapshot<ReadChildren> snapshot) {
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
                        children = snapshot.data.children;
                        return Expanded(
                          child: new ListView.builder(
                            itemCount: children.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: ListTile(
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














