import 'package:barcode_scan/barcode_scan.dart';
import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:basic_front/REST/LoginCalls.dart';
import 'package:basic_front/ScanQR.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';


class Staff_ActiveDashboard_Page extends StatefulWidget {
  Staff_ActiveDashboard_Page({Key key, this.title}) : super(key: key);

  final String title;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
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
        title: Text(widget.title),
        actions: <Widget>[
          buildProfileButton(context),
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
                            return Container(
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
                            );
                          }
                          break;
                      default:
                        return null;
                      }
                    }
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
                    onPressed: () => null,
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
            ),
          );
        else if(tab.text == "Volunteers")
          return Center(
              child: buildVolunteerList(),
          );
        else if(tab.text == "Roster")
          return Center(
              child: buildFlexRoster(context),
          );
        else
          return Center(
              child: buildSuspendedRoster(),
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














