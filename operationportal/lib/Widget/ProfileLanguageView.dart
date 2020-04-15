import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Training.dart';


class ProfileLanguagesPage extends StatefulWidget {
  ProfileLanguagesPage({Key key, this.languages,}) : super(key: key);

  final List<String> languages;

  @override
  ProfileLanguagesState createState() => ProfileLanguagesState();
}

class ProfileLanguagesState extends State<ProfileLanguagesPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Languages"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.languages.length > 0 ? Expanded(
            child: new ListView.builder(
              itemCount: widget.languages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: ListTile(
                    title: Text('${widget.languages[index]}',
                        style: TextStyle(color: Colors.white)),
                    dense: false,
                  ),
                  color: index%2 == 0 ? primaryWidgetColor : secondaryWidgetColor,
                );
              },
            ),
          )
              : Expanded(child: Center(child: Text("No Languages!", style: TextStyle(fontSize: 24))))
        ],
      ),
    );
  }

}