import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:operationportal/REST/Get_RetrieveVolunteerInfo.dart';
import 'package:operationportal/REST/Post_ConfirmVolunteerAttendance.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Volunteer.dart';

class VolunteerCheckInPage extends StatefulWidget
{
  VolunteerCheckInPage({Key key, this.storage}) : super(key: key);

  final Storage storage;

  @override
  VolunteerCheckInState createState() => VolunteerCheckInState();
}

class VolunteerCheckInState extends State<VolunteerCheckInPage>
{
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>
                  [
                    Flexible(
                      child: Text("Returning Volunteer", style: TextStyle(fontSize: 24, color: Colors.white),),
                    ),
                    Container(
                      child: FlatButton(
                        child: Text("Scan QR", style: TextStyle(color: Colors.black),),
                        onPressed: () => scan(),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(20)
                        ),
                      ),
                      margin: EdgeInsets.only(left: 20),
                    ),
                  ]
              ),
            ),
            decoration: new BoxDecoration(
              color: primaryWidgetColor,
              borderRadius: new BorderRadius.all(
                  new Radius.circular(20)
              ),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
          ),
          barcode == null || barcode.isEmpty ? Container() :
          FutureBuilder(
              future: widget.storage.readToken().then((value){
                return RetrieveVolunteerInfo(value, barcode, context);
              }),
              builder: (BuildContext context, AsyncSnapshot<Volunteer> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text('Issue Posting Data');
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  case ConnectionState.active:
                    return new Text('');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text("Press 'Scan QR' to begin!");
                    } else {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: IntrinsicHeight(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Container(
                                      child: CircleAvatar(
                                        backgroundImage: (snapshot.data.picture != null && snapshot.data.picture.isNotEmpty) ? MemoryImage(base64.decode((snapshot.data.picture))) : null,
                                      ),
                                      height: 200,
                                      width: 200,
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(right: 10),
                                    ),
                                    Flexible(
                                      child: Text(
                                        (snapshot.data.firstName) + "\n" + (snapshot.data.lastName),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 28, color: Colors.white),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            decoration: new BoxDecoration(
                              color: primaryWidgetColor,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20)
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                          ),
                          Container(
                              child: Text("Number of Weeks Attended: ${snapshot.data.weeksAttended}", style: TextStyle(fontSize: 20, color: Colors.white),),
                              decoration: new BoxDecoration(
                                color: primaryWidgetColor,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20)
                                ),
                              ),
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(top: 20)
                          ),
                          snapshot.data.birthday == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                              ? Container(
                                child: Text("Happy Birthday!", style: TextStyle(fontSize: 20, color: Colors.white),),
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20)
                                  ),
                                ),
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(top: 20)
                              ) : Container(),
                          snapshot.data.checkedIn
                              ? Container(
                                child: Text("Already Signed In", style: TextStyle(fontSize: 20, color: Colors.white),),
                                decoration: new BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20)
                                  ),
                                ),
                              padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(top: 100)
                              )
                              : Container(
                                child: FlatButton(
                                  child: Text("Sign In Volunteer", style: TextStyle(fontSize: 20, color: Colors.white),),
                                  onPressed: () {
                                    widget.storage.readToken().then((value) {
                                      ConfirmVolunteerAttendance(value, snapshot.data.id, context);
                                    });
                                  },
                                ),
                                decoration: new BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20)
                                  ),
                                ),
                                margin: EdgeInsets.only(top: 100)
                              ),
                        ],
                      );
                    }
                    break;
                  default:
                    return null;
                }
              }
          ),
        ],
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
