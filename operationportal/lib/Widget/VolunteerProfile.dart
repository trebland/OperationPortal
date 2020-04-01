import 'package:operationportal/Structs/Volunteer.dart';
import 'package:flutter/material.dart';

class VolunteerProfilePage extends StatefulWidget {
  VolunteerProfilePage({Key key, this.volunteer}) : super(key: key);

  final Volunteer volunteer;

  @override
  VolunteerProfileState createState() => VolunteerProfileState();
}

class VolunteerProfileState extends State<VolunteerProfilePage> {

  List<String> notes = ["Doesn't play well with Henry", "Loves Juice", "Dislikes Soccer", "Likes Monopoly"];

  final List<int> colorCodes = <int>[600, 500];

  Widget buildPictureNameRow_Volunteer (String title)
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>
            [
              Container(
                child: Image(
                    image: AssetImage('assets/OCC_LOGO_128_128.png')
                ),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(20)
                  ),
                ),
                height: 200,
                width: 200,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 10),
              ),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
    );
  }

  Widget buildFirstRowInfo ()
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
                        "Started Volunteering",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: Text(
                        "October 7th, 2018",
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
                          "Verification Forms Filled?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Yes",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildPictureNameRow_Volunteer(widget.volunteer.firstName + " " + widget.volunteer.lastName),
          buildFirstRowInfo(),
        ],
      ),
    );
  }
}