import 'package:flutter/material.dart';

import 'VolunteerCaptain_ActiveDashboard.dart';

class VolunteerCaptain_ProfileViewer_Page extends StatefulWidget {
  VolunteerCaptain_ProfileViewer_Page({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  VolunteerCaptain_ProfileViewer_State createState() => VolunteerCaptain_ProfileViewer_State();
}

class VolunteerCaptain_ProfileViewer_State extends State<VolunteerCaptain_ProfileViewer_Page> {

  List<String> notes = ["Doesn't play well with Henry", "Loves Juice", "Dislikes Soccer", "Likes Monopoly"];

  final List<int> colorCodes = <int>[600, 500];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ]
                ),
              ),
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
            ),
            Container(
              child: IntrinsicHeight(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Birthday",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                "September 5th, 2010",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Grade",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Text(
                                "4th",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ),
                    ]
                ),
              ),
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
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
                          "Notes",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.only(
                            topRight: new Radius.circular(20), topLeft: new Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                      Container(
                        child: FlatButton(
                          child: Text("Add Note", style: TextStyle(color: Colors.white)),
                          onPressed: () => null,
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        margin: EdgeInsets.only(left: 20),
                      ),
                    ]
                ),
              ),
              margin: EdgeInsets.only(top: 10, left: 10),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: ListTile(
                        title: Text('${notes[index]}',
                        style: TextStyle(color: Colors.white)),
                        trailing: PopupMenuButton<Choice>(
                          onSelected: _select,
                          itemBuilder: (BuildContext context) {
                            return ReturnDummyList();
                          },
                        ),
                        dense: false,
                      ),
                      color: Colors.blue[colorCodes[index%2]],
                    );
                  },
                ),
                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
              ),
            ),
          ],
        ),
    );
  }

  List<PopupMenuItem<Choice>> ReturnDummyList ()
  {
    List<PopupMenuItem<Choice>> list = new List<PopupMenuItem<Choice>>();
    list.add(PopupMenuItem<Choice>(
      value: new Choice("Edit"),
      child: Text("Edit"),
    ));
    return list;
  }

  void _select(Choice value) {
  }
}