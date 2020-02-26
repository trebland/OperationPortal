import 'package:flutter/material.dart';

import '../QR/GenerateQR.dart';

Widget buildPictureNameRow (String firstName, String lastName)
{
  return Container(
    child: IntrinsicHeight(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              margin: EdgeInsets.only(top: 10, right: 20)
            ),
            Flexible(
              child: Text(
                firstName + "\n" + lastName,
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

Widget buildQRButton (String accessToken, BuildContext context)
{
  return Container (
    child: FlatButton(
      child: const Text('Show QR Code', style: TextStyle(fontSize: 24, color: Colors.white)),
      onPressed: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(token: accessToken,)));
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