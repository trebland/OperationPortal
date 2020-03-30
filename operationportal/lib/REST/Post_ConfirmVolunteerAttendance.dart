import 'dart:convert';

import 'package:operationportal/Structs/Profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> ConfirmVolunteerAttendance (String token, Profile toConfirm, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/check-in/volunteer";

  var body = json.encode({
    'Id': '${toConfirm.id}'
  });

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {

    // If the call to the server was successful, parse the JSON.
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

  } else {

    Confirm_Failure mPost = Confirm_Failure.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    throw Exception('Failed to load post');
  }
}

class Confirm_Failure {
  String error;

  Confirm_Failure({this.error});

  factory Confirm_Failure.fromJson(Map<String, dynamic> json) {
    return Confirm_Failure(
      error: json['error'],
    );
  }
}