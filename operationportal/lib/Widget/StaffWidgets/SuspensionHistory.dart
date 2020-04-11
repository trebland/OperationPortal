import 'package:flutter/material.dart';
import 'package:operationportal/REST/Get_RetrieveSuspensionHistory.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Suspension.dart';
import 'package:operationportal/Structs/User.dart';


class SuspensionHistoryPage extends StatefulWidget {
  SuspensionHistoryPage({Key key, this.user, this.child}) : super(key: key);

  final User user;
  final RosterChild child;

  @override
  SuspensionHistoryState createState() => SuspensionHistoryState();
}

class SuspensionHistoryState extends State<SuspensionHistoryPage> {
  Storage storage;
  Bus bus;

  @override
  void initState() {
    storage = new Storage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suspension History"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
              future: storage.readToken().then((value) {
                return GetSuspensions(value, widget.child.id.toString());
              }),
              builder: (BuildContext context, AsyncSnapshot<List<Suspension>> snapshot) {
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
                        child: Text("No Suspensions Listed / Issues Connecting"),
                      );
                    } else {
                      return snapshot.data.isNotEmpty
                          ? Expanded(
                        child: new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: ListTile(
                                title: Text(formatDate('${snapshot.data[index].startSuspension}'.split(' ')[0]) + ' to ' + formatDate('${snapshot.data[index].endSuspension}'.split(' ')[0]),
                                    style: TextStyle(color: Colors.white)),
                                onTap: () => null,
                                dense: false,
                              ),
                              color: index%2 == 0 ? primaryWidgetColor : secondaryWidgetColor,
                            );
                          },
                        ),
                      )
                        : Center( child: Text("No Suspensions on Record!", style: TextStyle(fontSize: 24)));
                    }
                    break;
                  default:
                    return null;
                }
              }
          )
        ],
      ),
    );
  }
}