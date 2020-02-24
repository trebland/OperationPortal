import 'dart:convert';

import 'package:basic_front/Structs/Volunteer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<Volunteer> RetrieveUser (String token, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/auth/user";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Volunteer mPost = Volunteer.fromJson(json.decode(response.body));

    return mPost;
  } else {
    // If that call was not successful, throw an error.
    RetrieveUser_Failure mPost = RetrieveUser_Failure.fromJson(json.decode(response.body));

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

class RetrieveUser_Failure {
  String error;

  RetrieveUser_Failure({this.error});

  factory RetrieveUser_Failure.fromJson(Map<String, dynamic> json) {
    return RetrieveUser_Failure(
      error: json['error'],
    );
  }
}