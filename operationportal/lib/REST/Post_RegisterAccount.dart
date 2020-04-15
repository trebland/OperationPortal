import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Widget/LoadingScreen.dart';

Future<void> RegisterAccount(BuildContext context, String email,
    String password, String firstName, String lastName, String imagePath) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Registering Account",)));
  var mUrl = "https://www.operation-portal.com/api/auth/register";

  Map<String, dynamic> bodyToSet = {
    "Email": '$email',
    "Password": '$password',
    "FirstName": '$firstName',
    "LastName": '$lastName',
  };

  if (imagePath != null && imagePath.isNotEmpty)
  {
    Uint8List bytes = (await File(imagePath).readAsBytes());
    Map<String, dynamic> addTo = {
      'Picture': bytes,
    };
    bodyToSet.addAll(addTo);
  }

  var body = json.encode(bodyToSet);

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json'});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.

    Fluttertoast.showToast(
        msg: "Account created successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  } else {
    // If that call was not successful, throw an error.
    Register_Response mPost = Register_Response.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.error,
        toastLength: Toast.LENGTH_SHORT,
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

class Register_Response {
  final String error;
  final String name;

  Register_Response({this.error, this.name});

  factory Register_Response.fromJson(Map<String, dynamic> json) {
    return Register_Response(
      error: json['error'],
      name: json['name'],
    );
  }
}