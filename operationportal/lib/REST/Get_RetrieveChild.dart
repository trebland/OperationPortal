import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/Child.dart';

Future<Child> RetrieveChild (String token, String id, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child?id=$id";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Child mPost = Child.fromJson(json.decode(response.body));

    return mPost;
  } else {
    // If that call was not successful, throw an error.
    RetrieveChild_Failure mPost = RetrieveChild_Failure.fromJson(json.decode(response.body));

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

class RetrieveChild_Failure {
  String error;

  RetrieveChild_Failure({this.error});

  factory RetrieveChild_Failure.fromJson(Map<String, dynamic> json) {
    return RetrieveChild_Failure(
      error: json['error'],
    );
  }
}