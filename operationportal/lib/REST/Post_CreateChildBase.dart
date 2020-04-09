import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> CreateChildBase (String token, String firstName, String lastName, String parentName, String contactNumber, String busId, String childImagePath, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";

  var body;

  Map<String, dynamic> bodyToSet = {
    'FirstName': firstName,
    'ParentName': parentName,
    'ContactNumber': contactNumber,
    'BusId': busId,
  };

  if (lastName.isNotEmpty) {
    Map<String, dynamic> addTo = {
      'lastName': lastName,
    };
    bodyToSet.addAll(addTo);
  }

  if (childImagePath == null)
  {
    Uint8List bytes = (await File(childImagePath).readAsBytes());
    Map<String, dynamic> addTo = {
      'Picture': bytes,
    };
    bodyToSet.addAll(addTo);
  }

  body = json.encode(bodyToSet);

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200)
  {
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );


    Navigator.pop(context);

  } else {
    CreateChild_Failure mPost = CreateChild_Failure.fromJson(jsonDecode(response.body));

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

class CreateChild_Failure {
  String error;

  CreateChild_Failure({this.error});

  factory CreateChild_Failure.fromJson(Map<String, dynamic> json) {
    return CreateChild_Failure(
      error: json['error'],
    );
  }
}