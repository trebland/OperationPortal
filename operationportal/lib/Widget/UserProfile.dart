import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Widget/ProfileLanguageView.dart';
import 'package:operationportal/Widget/ProfileTrainingView.dart';

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
                    backgroundImage: (widget.profile.picture != null) ? MemoryImage(base64.decode((widget.profile.picture))) : null,
                  ),
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.only(top: 10, right: 20)
              ),
              Flexible(
                child: Text(
                  widget.profile.firstName + "\n" + widget.profile.lastName,
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

  Widget buildContactInfo ()
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
                        "Email",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${widget.profile.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Phone Number",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.profile.phone != null && widget.profile.phone.isNotEmpty ? formatNumber(widget.profile.phone) : "N/A",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
    );
  }

  Widget buildSecondRowInfo ()
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
                        "Started in",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${widget.profile.yearStarted}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Weeks Attended",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${widget.profile.weeksAttended}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
    );
  }

  Widget buildThirdRowInfo()
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
                          "Orientation Completed?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.profile.orientation ? "Yes" : "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Contact When Short?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.profile.contactWhenShort ? "Yes" : "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "Background Check Completed?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.profile.backgroundCheck ? "Yes" : "No",
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

  Widget buildFourthRowInfo ()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                child: FlatButton(
                  child: Text("Trainings", style: TextStyle(color: textComplementColor)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileTrainingPage(trainings: widget.profile.trainings,)));
                  },
                ),
                decoration: new BoxDecoration(
                  color: primaryWidgetColor,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(20)
                  ),
                ),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 10),
              ),
              Container(
                child: FlatButton(
                  child: Text("Languages", style: TextStyle(color: textComplementColor)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileLanguagesPage(languages: widget.profile.languages,)));
                  },
                ),
                decoration: new BoxDecoration(
                  color: primaryWidgetColor,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(20)
                  ),
                ),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 10, bottom: 10),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
    );
  }

  Widget buildFifthRowInfo()
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
                        child: IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>
                              [
                                Container(
                                  child: FlatButton(
                                    child: Text("Copy Website URL",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20, color: textComplementColor)),
                                    onPressed: () {
                                      Clipboard.setData(new ClipboardData(text: "https://www.operation-portal.com/"));
                                      Fluttertoast.showToast(
                                          msg: "Copied to Clipboard",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    },
                                  ),
                                  decoration: new BoxDecoration(
                                    color: primaryWidgetColor,
                                    borderRadius: new BorderRadius.all(
                                      new Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                      ),
                      Container(
                        child: Text(
                          "https://www.operation-portal.com/",
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
          title: Text("User Profile"),
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
                    buildSecondRowInfo(),
                    buildThirdRowInfo(),
                    buildFourthRowInfo(),
                    buildFifthRowInfo(),
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