import 'package:basic_front/Staff/Staff_ProfileViewer.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_ProfileViewer.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_VolunteerProfileViewer.dart';
import 'package:flutter/material.dart';

import '../ChildAddition/AddChild.dart';
import '../Structs/Choice.dart';


final List<int> colorCodes = <int>[600, 500];
final items = List<String>.generate(50, (i) => "Item $i");
List<String> names = ["Jacob Pfeiffer", "Marcus O'Real", "Kevin Augustus", "Stella Artois", "Guillaume Fuile", "Ruby Jack", "Lika Telova", "Rika Telova", "Vila Malie", "Marie Goodman"];
List<String> volunteerNames = ["Richard Hemsworth", "Lexicon Grubert", "Tyrell Smith", "Alessa Tuford"];

void _select(Choice choice) {
  // Causes the app to rebuild with the new _selectedChoice.
}

List<PopupMenuItem<Choice>> ReturnDummyList ()
{
  List<PopupMenuItem<Choice>> list = new List<PopupMenuItem<Choice>>();
  list.add(PopupMenuItem<Choice>(
    value: new Choice("View"),
    child: Text("View"),
  ));
  return list;
}

List<String> suspendedNames = ["Mitch Hammock", "Tigger", "Winnie the Pooh", "Thomas Anchor"];

Widget buildSuspendedRoster ()
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
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
      Expanded(
        child: new ListView.builder(
          itemCount: suspendedNames.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                title: Text('${suspendedNames[index]}',
                    style: TextStyle(color: Colors.white)),
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ProfileViewer_Page(title: '${suspendedNames[index]}')));
                },
                dense: false,
              ),
              color: Colors.blue[colorCodes[index%2]],
            );
          },
        ),
      ),
    ],
  );
}

Widget buildStaffFlexRoster (BuildContext context)
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
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
      Expanded(
        child: new ListView.builder(
          itemCount: names.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                title: Text('${names[index]}',
                    style: TextStyle(color: Colors.white)),
                trailing: PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return ReturnDummyList();
                  },
                ),
                onTap: ()
                {

                },
                dense: false,
              ),
              color: Colors.blue[colorCodes[index%2]],
            );
          },
        ),
      ),
    ],
  );
}

Widget buildFlexRoster (BuildContext context)
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
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
      Expanded(
        child: new ListView.builder(
          itemCount: names.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                title: Text('${names[index]}',
                    style: TextStyle(color: Colors.white)),
                trailing: PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return ReturnDummyList();
                  },
                ),
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ProfileViewer_Page(title: '${names[index]}')));
                },
                dense: false,
              ),
              color: Colors.blue[colorCodes[index%2]],
            );
          },
        ),
      ),
    ],
  );
}

Widget buildStaticRoster (BuildContext context)
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
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
      Expanded(
        child: new ListView.builder(
          itemCount: names.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                title: Text('${names[index]}',
                    style: TextStyle(color: Colors.white)),
                trailing: PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return ReturnDummyList();
                  },
                ),
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ProfileViewer_Page(title: '${names[index]}')));
                },
                dense: false,
              ),
              color: Colors.blue[colorCodes[index%2]],
            );
          },
        ),
      ),
    ],
  );
}

Widget buildVolunteerList ()
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
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
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ]
          ),
        ),
        margin: EdgeInsets.all(10),
      ),
      Expanded(
        child: new ListView.builder(
          itemCount: volunteerNames.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                title: Text('${volunteerNames[index]}',
                    style: TextStyle(color: Colors.white)),
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_VolunteerProfileViewer_Page(title: '${volunteerNames[index]}')));
                },
                dense: false,
              ),
              color: Colors.blue[colorCodes[index%2]],
            );
          },
        ),
      ),
    ],
  );
}