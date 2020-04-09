import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/ChildAddition/AddChild.dart';
import 'package:operationportal/REST/Get_RetrieveBuses.dart';
import 'package:operationportal/REST/Get_RetrieveClasses.dart';
import 'package:operationportal/REST/Get_RetrieveRoster.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/StaffWidgets/BusProfile.dart';
import 'package:operationportal/Widget/StaffWidgets/ChildProfile.dart';
import 'package:operationportal/Widget/StaffWidgets/ClassProfile.dart';


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
  final busRouteController = TextEditingController();
  final classIdController = TextEditingController();
  final searchController = TextEditingController();

  int busIndex;
  Bus selectedBus;
  int classIndex;
  Class selectedClass;
  
  bool filterCheckedIn;

  List<String> busIds;
  List<String> classIds;

  List<RosterChild> displayChildren;
  List<RosterChild> children;
  List<RosterChild> childrenData;
  
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
                      color: primaryWidgetColor,
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
                                          setState(() {
                                            busIndex = snapshot.data.indexOf(newValue);
                                            selectedBus = newValue.id == null ? null : newValue;
                                            busRouteController.text = newValue.name == null ? "N/A" : '${newValue.name}';
                                          });
                                        },
                                        items: snapshot.data
                                            .map<DropdownMenuItem<Bus>>((Bus value) {
                                          return DropdownMenuItem<Bus>(
                                            value: value,
                                            child: value.id == null ? Text('Select Bus', style: TextStyle(fontSize: 16, decoration: TextDecoration.none,)) : Text('${value.name}', style: TextStyle(fontSize: 16, decoration: TextDecoration.none,)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          if (snapshot.data[busIndex].id != null)
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => BusProfilePage(bus: snapshot.data[busIndex],)));
                                        },
                                        child: Text("Info", style: TextStyle(color: Colors.white)),
                                      ),
                                      decoration: new BoxDecoration(
                                        color: primaryWidgetColor,
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
                      color: primaryWidgetColor,
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
                                          setState(() {
                                            classIndex = snapshot.data.indexOf(newValue);
                                            selectedClass = newValue.id == null ? null : newValue;
                                            classIdController.text = newValue.name == null ? "No Associated Name" : '${selectedClass.name}';

                                          });
                                        },
                                        items: snapshot.data
                                            .map<DropdownMenuItem<Class>>((Class value) {
                                          return DropdownMenuItem<Class>(
                                            value: value,
                                            child: value.id == null ? Text('Select Class', style: TextStyle(fontSize: 16, decoration: TextDecoration.none,)) : Text('${value.name}', style: TextStyle(fontSize: 16, decoration: TextDecoration.none,)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          if (snapshot.data[classIndex].id != null)
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ClassProfilePage(mClass: snapshot.data[classIndex],)));
                                        },
                                        child: Text("Info", style: TextStyle(color: Colors.white)),
                                      ),
                                      decoration: new BoxDecoration(
                                        color: primaryWidgetColor,
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
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddChildPage(futureBuses: null, driversBus: null)))
                      )
                  )
                ]
            ),
          ),
          margin: EdgeInsets.only(left: 10, bottom: 10),
        ),
        FutureBuilder(
            future: widget.storage.readToken().then((value) {
              return RetrieveRoster(value, selectedBus == null ? "" : '${selectedBus.id}', selectedClass == null ? "" : '${selectedClass.id}');
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
                    children = searchController.text.isNotEmpty ? displayChildren : childrenData;
                    children = filterCheckedIn ? filterChildren (children) : children;
                    children = sortedChildren(children);
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChildProfileViewerPage(user: widget.user, child: children[index])));
                              },
                              dense: false,
                            ),
                            color: index%2 == 0 ? primaryWidgetColor : secondaryWidgetColor,
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