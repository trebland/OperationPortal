import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/References/ReferenceFunctions.dart';
import 'package:operationportal/Structs/Volunteer.dart';
import 'package:operationportal/Widget/ProfileLanguageView.dart';
import 'package:operationportal/Widget/ProfileTrainingView.dart';

class VolunteerProfilePage extends StatefulWidget {
  VolunteerProfilePage({Key key, this.volunteer}) : super(key: key);

  final Volunteer volunteer;

  @override
  VolunteerProfileState createState() => VolunteerProfileState();
}

class VolunteerProfileState extends State<VolunteerProfilePage> {

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
                    backgroundImage: (widget.volunteer.picture != null) ? MemoryImage(base64.decode((widget.volunteer.picture))) : null,
                  ),
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.only(top: 10, right: 20)
              ),
              Flexible(
                child: Text(
                  widget.volunteer.firstName + "\n" + widget.volunteer.lastName,
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
                        '${widget.volunteer.email}',
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
                          widget.volunteer.phone != null && widget.volunteer.phone.isNotEmpty ? formatNumber(widget.volunteer.phone) : "N/A",
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
                        '${widget.volunteer.yearStarted}',
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
                        '${widget.volunteer.weeksAttended}',
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
                          widget.volunteer.orientation ? "Yes" : "No",
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
                          widget.volunteer.contactWhenShort ? "Yes" : "No",
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
                          widget.volunteer.backgroundCheck ? "Yes" : "No",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileTrainingPage(trainings: widget.volunteer.trainings,)));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileLanguagesPage(languages: widget.volunteer.languages,)));
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