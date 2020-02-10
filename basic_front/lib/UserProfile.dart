import 'package:flutter/material.dart';

import 'BuildPresets/InactiveDashboard.dart';
import 'Structs/Profile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.profile}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Profile profile;

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage>
{

  @override
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text('Profile'),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildPictureNameRow(widget.profile.firstName, widget.profile.lastName),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}