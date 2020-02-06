import 'package:flutter/material.dart';

import 'BuildPresets/InactiveDashboard.dart';

class QRPage extends StatefulWidget {
  QRPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  QRState createState() => QRState();
}

class QRState extends State<QRPage>
{

  @override
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text(widget.title),
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

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}