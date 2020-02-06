import 'package:flutter/material.dart';

import '../GenerateQR.dart';

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(title: 'Bus-Driver')));
        else if (role == "vc")
          Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(title: 'Volunteer-Captain')));
        else
          Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(title: 'Volunteer')));
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