//
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Widget/LoadingScreen.dart';

Future<void> ResetPassword(BuildContext context, String email) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Sending Email",)));
  var mUrl = "https://www.operation-portal.com/api/auth/password-reset-request";

  var body = json.encode({
    "Email": '$email',
  });

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json'});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.

    Fluttertoast.showToast(
        msg: "Reset Password Email Sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  } else {
    Fluttertoast.showToast(
        msg: "Account may not exist/Error resetting password",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.pop(context);
    throw Exception('Failed to load post');
  }
}