
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/Storage.dart';

class ClassProfilePage extends StatefulWidget {
  ClassProfilePage({Key key, this.mClass}) : super(key: key);

  final Class mClass;

  @override
  ClassProfileState createState() => ClassProfileState();
}

class ClassProfileState extends State<ClassProfilePage> {

  Storage storage;

  @override
  void initState() {
    storage = new Storage();

    super.initState();
  }

  Widget buildPictureNameRow ()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                  child: CircleAvatar(
                    backgroundImage: (widget.mClass.teacherPicture != null && widget.mClass.teacherPicture.isNotEmpty) ? MemoryImage(base64.decode((widget.mClass.teacherPicture))) : null,
                  ),
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.only(top: 10, right: 20)
              ),
              Flexible(
                child: Text(
                  widget.mClass.teacherName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.all(10),
    );
  }

  Widget buildAdditionalInfo()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Class Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          widget.mClass.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Number of Students",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          '${widget.mClass.numStudents}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Location",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: textComplementColor),
                        ),
                        decoration: new BoxDecoration(
                          color: primaryWidgetColor,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20)
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Text(
                          widget.mClass.location,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  )
              ),
            ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        AppBar appBar = AppBar(
          title: Text("Class Info"),
        );
        return Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    buildPictureNameRow(),
                    buildAdditionalInfo(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}