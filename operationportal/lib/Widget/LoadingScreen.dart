import 'package:flutter/material.dart';
import 'package:operationportal/QR/GenerateQR.dart';
import 'package:operationportal/Structs/Profile.dart';

import 'file:///C:/Users/gecco/Documents/GitHub/OperationPortal/operationportal/lib/Widget/AppBar.dart';

class LoadingScreenPage extends StatefulWidget {
  LoadingScreenPage({Key key, this.title}) : super(key: key);

  String title;

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreenPage>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      resizeToAvoidBottomPadding: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: CircularProgressIndicator(strokeWidth: 14,),
                height: 200.0,
                width: 200.0,
                margin: EdgeInsets.all(20),
              ),
              Text(widget.title + (" (Please wait...)"), style: TextStyle(fontSize: 24)),
            ],
          )
        ],
      ),
    );
  }
}