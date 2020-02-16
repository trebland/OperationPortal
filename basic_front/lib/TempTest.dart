import 'package:flutter/material.dart';

import 'BuildPresets/InactiveDashboard.dart';
import 'Structs/Child.dart';
import 'Structs/Profile.dart';

class TempPage extends StatefulWidget {
  TempPage({Key key, this.children}) : super(key: key);

  final List<Child> children;

  @override
  TempState createState() => TempState();
}

class TempState extends State<TempPage>
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
                  Container(
                    child: new ListView.builder(
                      itemCount: widget.children.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: ListTile(
                            title: Text('${widget.children[index].firstName}',
                                style: TextStyle(color: Colors.white)),
                            onTap: () => null,
                            dense: false,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}