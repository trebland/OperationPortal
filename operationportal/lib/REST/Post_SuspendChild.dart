import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Widget/LoadingScreen.dart';

Future<void> SuspendChild (String token, int id, String start, String end, BuildContext context)
async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Suspending Child",)));
  var mUrl = "https://www.operation-portal.com/api/suspend";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var body = json.encode({
    'id': id,
    'start': start,
    'end': end,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: headers);

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: 'Child Suspended',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );


    Navigator.pop(context);
    Navigator.pop(context, true);
  } else {

    Navigator.pop(context, false);
    return null;
  }
}

class SuspendResponse {
  List<RosterChild> suspended;

  SuspendResponse({this.suspended});

  factory SuspendResponse.fromJson(Map<String, dynamic> json) {
    return SuspendResponse(
      suspended: json['suspensions'].map<RosterChild>((value) => new RosterChild.fromJson(value)).toList(),
    );
  }
}