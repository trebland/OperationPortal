import 'dart:convert';

import 'package:basic_front/Structs/Class.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<Class> RetrieveClassInfo (String token, String id, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/bus-info?id=$id";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Class mPost = Class.fromJson(json.decode(response.body));

    return mPost;
  } else {
    // If that call was not successful, throw an error.
    RetrieveClassInfo_Failure mPost = RetrieveClassInfo_Failure.fromJson(json.decode(response.body));

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

class RetrieveClassInfo_Failure {
  String error;

  RetrieveClassInfo_Failure({this.error});

  factory RetrieveClassInfo_Failure.fromJson(Map<String, dynamic> json) {
    return RetrieveClassInfo_Failure(
      error: json['error'],
    );
  }
}