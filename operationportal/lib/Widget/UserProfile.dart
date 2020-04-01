import 'package:flutter/material.dart';

import '../Structs/Profile.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key key, this.profile}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Profile profile;

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfilePage>
{
  Widget buildPictureNameRow (String firstName, String lastName)
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                  child: CircleAvatar(),
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.only(top: 10, right: 20)
              ),
              Flexible(
                child: Text(
                  firstName + "\n" + lastName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 10, right: 10),
    );
  }

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