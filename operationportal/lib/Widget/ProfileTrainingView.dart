import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Training.dart';


class ProfileTrainingPage extends StatefulWidget {
  ProfileTrainingPage({Key key, this.trainings,}) : super(key: key);

  final List<Training> trainings;

  @override
  ProfileTrainingState createState() => ProfileTrainingState();
}

class ProfileTrainingState extends State<ProfileTrainingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trainings"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.trainings.length > 0 ? Expanded(
            child: new ListView.builder(
              itemCount: widget.trainings.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: ListTile(
                    title: Text('${widget.trainings[index].name}',
                        style: TextStyle(color: Colors.white)),
                    dense: false,
                  ),
                  color: index%2 == 0 ? primaryWidgetColor : secondaryWidgetColor,
                );
              },
            ),
          )
              : Expanded(child: Center(child: Text("No Trainings!", style: TextStyle(fontSize: 24))))
        ],
      ),
    );
  }

}