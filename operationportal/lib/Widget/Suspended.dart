import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/REST/Get_RetrieveSuspendedRoster.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/SemiChildProfile.dart';
import 'package:operationportal/Widget/StaffWidgets/ChildProfile.dart';


class SuspendedWidgetPage extends StatefulWidget {
  SuspendedWidgetPage({Key key, this.storage, this.user}) : super(key: key);

  final Storage storage;
  final User user;

  @override
  SuspendedWidgetState createState() => SuspendedWidgetState();
}
class SuspendedWidgetState extends State<SuspendedWidgetPage>
{
  List<RosterChild> displaySuspended = new List<RosterChild>();
  List<RosterChild> suspended = new List<RosterChild>();
  List<RosterChild> suspendedData = new List<RosterChild>();

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

  @override
  Widget build(BuildContext context) {
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
            future: widget.storage.readToken().then((value) {
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
                                  backgroundImage: (suspended[index].picture != null && suspended[index].picture.isNotEmpty) ? MemoryImage(base64.decode((suspended[index].picture))) : null,
                                ),
                              ),
                              title: Text('${suspended[index].firstName} ' + '${suspended[index].lastName}',
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text('${suspended[index].startSuspension != null && suspended[index].endSuspension != null ? formatDate('${suspended[index].startSuspension.split('T')[0]}') + ' to ' + formatDate('${suspended[index].endSuspension.split('T')[0]}') : 'No Suspension Information'}', style: TextStyle(color: Colors.white)),
                              onTap: ()
                              {
                                widget.user.profile.role == "Staff"
                                ? Navigator.push(context, MaterialPageRoute(builder: (context) => ChildProfileViewerPage(user: widget.user, child: suspended[index])))
                                : Navigator.push(context, MaterialPageRoute(builder: (context) => SemiChildProfilePage(profile: widget.user.profile, child: suspended[index])));
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