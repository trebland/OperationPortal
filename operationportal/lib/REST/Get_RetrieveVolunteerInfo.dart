/*
api/volunteer-info?id=int*/


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/Volunteer.dart';

Future<Volunteer> RetrieveVolunteerInfo (String token, String id, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/volunteer-info?id=$id";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    RetrieveSuccess mPost = RetrieveSuccess.fromJson(json.decode(response.body));

    return mPost.volunteer;
  } else {
    // If that call was not successful, throw an error.
    RetrieveError mPost = RetrieveError.fromJson(json.decode(response.body));

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

class RetrieveSuccess {
  Volunteer volunteer;

  RetrieveSuccess({this.volunteer});

  factory RetrieveSuccess.fromJson(Map<String, dynamic> json) {
    return RetrieveSuccess(
      volunteer: Volunteer.fromJson(json['volunteer']),
    );
  }
}

class RetrieveError {
  String error;

  RetrieveError({this.error});

  factory RetrieveError.fromJson(Map<String, dynamic> json) {
    return RetrieveError(
      error: json['error'],
    );
  }
}