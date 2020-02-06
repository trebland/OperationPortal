import 'package:basic_front/BuildPresets/ActiveDashboard.dart';
import 'package:basic_front/BuildPresets/AppBar.dart';
import 'package:flutter/material.dart';

class BusDriver_ActiveDashboard_Page extends StatefulWidget {
  BusDriver_ActiveDashboard_Page({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  BusDriver_ActiveDashboard_State createState() => BusDriver_ActiveDashboard_State();
}

class BusDriver_ActiveDashboard_State extends State<BusDriver_ActiveDashboard_Page> with SingleTickerProviderStateMixin
{

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Dashboard'),
    Tab(text: 'Roster'),
    Tab(text: 'Suspended'),
  ];

  final List<int> colorCodes = <int>[600, 500];

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
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>
                        [
                          Container(
                            child: Text("Recent Child", style: TextStyle(fontSize: 40, color: Colors.white),),
                            margin: EdgeInsets.only(right: 20),
                          ),
                          Container(
                            child: FlatButton(
                              child: Text("Scan QR", style: TextStyle(color: Colors.black),),
                              onPressed: () => null,
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20)
                              ),
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
                Expanded(
                  child:
                  Container(
                    child: IntrinsicHeight(
                      child: Column(
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
                              margin: EdgeInsets.only(bottom: 10),
                            ),
                            Flexible(
                              child: Text(
                                "First-Name\nLast-Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40, color: Colors.white),
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
                ),
                Container(
                  child: FlatButton(
                    child: Text("Confirm Attendance", style: TextStyle(fontSize: 20, color: Colors.white),),
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
          );
        else if(tab.text == "Roster")
          return Center(
            child: buildStaticRoster(context),
          );
        else
          return Center(
              child: buildSuspendedRoster(),
          );
      }).toList(),
    ),
    );
  }
}














