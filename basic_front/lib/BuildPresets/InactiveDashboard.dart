import 'package:basic_front/Bus_Driver/BusDriver_ActiveDashboard.dart';
import 'package:basic_front/Volunteer/Volunteer_ActiveDashboard.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_ActiveDashboard.dart';
import 'package:flutter/material.dart';

Widget buildPictureNameRow ()
{
  return Container(
    child: IntrinsicHeight(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>
          [
            Container(
                decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(20)
                  ),
                ),
                height: 200,
                width: 200,
              margin: EdgeInsets.only(top: 10)
            ),
            Flexible(
              child: Text(
                "First-Name\nLast-Name",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40),
              ),
            ),
          ]
      ),
    ),
    margin: EdgeInsets.only(left: 10, right: 10),
  );
}

Widget buildQRButton (BuildContext context, String role)
{
  return Container (
    child: FlatButton(
      child: const Text('Scan QR Code', style: TextStyle(fontSize: 24, color: Colors.white)),
      onPressed: ()
      {
        if (role == "bd")
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusDriver_ActiveDashboard_Page(title: 'Dashboard')));
        else if (role == "vc")
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ActiveDashboard_Page(title: 'Dashboard')));
        else
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_ActiveDashboard_Page(title: 'Dashboard')));
      },
    ),
    decoration: new BoxDecoration(
      color: Colors.blue,
      borderRadius: new BorderRadius.all(
          new Radius.circular(20)
      ),
    ),
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(top: 20, bottom: 5),
  );
}

Widget buildNotice ()
{
  return Container(
    child: Text("Please present your QR code to staff in-order to begin volunteering.", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, color: Colors.blue)),
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.only(top: 20, bottom: 5),
  );
}