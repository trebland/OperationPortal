import 'package:flutter/material.dart';

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