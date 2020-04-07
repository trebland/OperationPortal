import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> RegisterAccount(BuildContext context, String email, String password, String firstName, String lastName) async {
  var mUrl = "https://www.operation-portal.com/api/auth/register";

  var body = json.encode({
    "Email": '$email',
    "Password": '$password',
    "FirstName": '$firstName',
    "LastName": '$lastName',
  });

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json'});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.

    Navigator.pop(context);
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