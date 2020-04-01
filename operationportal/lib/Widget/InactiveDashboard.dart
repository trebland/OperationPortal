import 'package:flutter/material.dart';
import 'package:operationportal/QR/GenerateQR.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Widget/AppBar.dart';


class InactiveDashboardPage extends StatefulWidget {
  InactiveDashboardPage({Key key, this.profile, this.accessToken}) : super(key: key);

  Profile profile;
  final String accessToken;

  @override
  InactiveDashboardState createState() => InactiveDashboardState();
}

class InactiveDashboardState extends State<InactiveDashboardPage>
{
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
                child: CircleAvatar(),
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

  Widget buildQRButton (String id, String accessToken, BuildContext context)
  {
    return Container (
      child: FlatButton(
        child: const Text('Show QR Code', style: TextStyle(fontSize: 24, color: Colors.white)),
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => QRPage(id: id, token: accessToken,)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          buildLogoutButton(context),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildPictureNameRow(widget.profile.firstName, widget.profile.lastName),
          buildQRButton('${widget.profile.id}', widget.accessToken, context),
          buildNotice(),
        ],
      ),
    );
  }
}