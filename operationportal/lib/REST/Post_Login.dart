import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../Structs/Storage.dart';
import 'Get_RetrieveUserAndPush.dart';

Future<void> Login(String username, String passwordText, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/auth/token";

  Map<String, String> body = {
    'grant_type': 'password',
    'username': '$username',
    'password': '$passwordText',
  };

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/x-www-form-urlencoded'});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Login_Response mPost = Login_Response.fromJson(json.decode(response.body));
    Storage storage = new Storage();

    storage.writeToken(mPost.accessToken);
    RetrieveUserAndPush(mPost.accessToken, context);
  } else {
    // If that call was not successful, throw an error.

    Fluttertoast.showToast(
        msg: "Email or password is incorrect",
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

class Login_Response {
  final String accessToken;
  final String errorDescription;

  Login_Response({this.accessToken, this.errorDescription});

  factory Login_Response.fromJson(Map<String, dynamic> json) {
    return Login_Response(
      accessToken: json['access_token'],
      errorDescription: json['error_description'],
    );
  }
}