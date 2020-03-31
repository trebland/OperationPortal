import 'dart:convert';

import 'package:operationportal/Staff/Staff_BusViewer.dart';
import 'package:operationportal/REST/Get_RetrieveBuses.dart';
import 'package:operationportal/REST/Get_RetrieveClasses.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/ChildAddition/AddChild.dart';
import 'package:operationportal/REST/Get_RetrieveRoster.dart';
import 'package:operationportal/Staff/Staff_ClassViewer.dart';
import 'package:operationportal/Staff/Staff_ProfileViewer.dart';
import 'package:operationportal/Storage.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RosterWidgetPage extends StatefulWidget {
  RosterWidgetPage({Key key, this.storage, this.user, this.futureBuses, this.futureClasses}) : super(key: key);

  final Storage storage;
  final User user;
  Future<List<Bus>> futureBuses;
  Future<List<Class>> futureClasses;

  @override
  RosterWidgetState createState() => RosterWidgetState();
}

class RosterWidgetState extends State<RosterWidgetPage>
{
  final List<int> colorCodes = <int>[600, 500];

  final busRouteController = TextEditingController();
  final classIdController = TextEditingController();
  final searchController = TextEditingController();
  
  String busRouteValue;
  int busIndex;
  String classIdValue;
  int classIndex;
  
  bool filterCheckedIn;

  List<String> busIds;
  List<String> classIds;

  List<RosterChild> displayChildren;
  List<RosterChild> children;
  List<RosterChild> childrenData;

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

  List<RosterChild> filterChildren (List<RosterChild> children)
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
  void initState() {
    busRouteValue = "Select Route";
    classIdValue = "Select Class";

    filterCheckedIn = false;

    busIds = new List<String>();
    classIds = new List<String>();

    displayChildren = new List<RosterChild>();
    children = new List<RosterChild>();
    childrenData = new List<RosterChild>();

    classIndex = 0;
    busIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Text("Bus Id", textAlign: TextAlign.center,
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
                  FutureBuilder(
                      future: widget.futureBuses == null ? widget.storage.readToken().then((value) async {
                        widget.futureBuses = RetrieveBuses(value);
                        return widget.futureBuses;
                      }) : widget.futureBuses,
                      builder: (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return new Text('Issue Posting Data');
                          case ConnectionState.waiting:
                            return new Center(child: new CircularProgressIndicator());
                          case ConnectionState.active:
                            return new Text('');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Unable to Fetch Roster (May be an unassigned route!)"),
                              );
                            } else {
                              if (snapshot.data[0].id != null)
                                snapshot.data.insert(0, new Bus());
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>
                                  [
                                    Container(
                                      child: DropdownButton<Bus>(
                                        value: snapshot.data[busIndex],
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
                                        onChanged: (Bus newValue) {
                                          busIndex = snapshot.data.indexOf(newValue);
                                          busRouteValue = newValue.id == null ? "" : '${newValue.id}';
                                          busRouteController.text = newValue.id == null ? "" : '${newValue.id}';
                                          setState(() {
                                          });
                                        },
                                        items: snapshot.data
                                            .map<DropdownMenuItem<Bus>>((Bus value) {
                                          return DropdownMenuItem<Bus>(
                                            value: value,
                                            child: value.id == null ? Text('Select Bus') : Text('${value.id}'),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          if (snapshot.data[busIndex].id != null)
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_BusViewer_Page(bus: snapshot.data[busIndex],)));
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
                              );
                            }
                            break;
                          default:
                            return null;
                        }
                      }
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
                  FutureBuilder(
                      future: widget.futureClasses == null ? widget.storage.readToken().then((value) {
                        widget.futureClasses = RetrieveClasses(value);
                        return widget.futureClasses;
                      }) : widget.futureClasses,
                      builder: (BuildContext context, AsyncSnapshot<List<Class>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return new Text('Issue Posting Data');
                          case ConnectionState.waiting:
                            return new Center(child: new CircularProgressIndicator());
                          case ConnectionState.active:
                            return new Text('');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Unable to Fetch Roster (May be an unassigned route!)"),
                              );
                            } else {
                              if (snapshot.data[0].id != null)
                                snapshot.data.insert(0, new Class());
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>
                                  [
                                    Container(
                                      child: DropdownButton<Class>(
                                        value: snapshot.data[classIndex],
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
                                        onChanged: (Class newValue) {
                                          classIndex = snapshot.data.indexOf(newValue);
                                          classIdValue = newValue.id == null ? "" : '${newValue.id}';
                                          classIdController.text = newValue.id == null ? "" : '${newValue.id}';
                                          setState(() {
                                          });
                                        },
                                        items: snapshot.data
                                            .map<DropdownMenuItem<Class>>((Class value) {
                                          return DropdownMenuItem<Class>(
                                            value: value,
                                            child: value.id == null ? Text('Select Class') : Text('${value.id}'),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          if (snapshot.data[classIndex].id != null)
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_ClassViewer_Page(mClass: snapshot.data[classIndex],)));
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
                              );
                            }
                            break;
                          default:
                            return null;
                        }
                      }
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
              setState(() {
                filterCheckedIn = !filterCheckedIn;
              });
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
            future: widget.storage.readToken().then((value) {
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
                    filterCheckedIn ? children = filterChildren (children) : children;
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
  }
}