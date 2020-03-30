import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> CreateChildBase (String token, String firstName, String lastName, String parentName, String contactNumber, String childImagePath, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";
  var body;
  Uint8List bytes;

  if (lastName.isEmpty && childImagePath == null)
    body = json.encode({
      'FirstName': firstName,
      'ParentName': parentName,
      'ContactNumber': contactNumber,
    });
  else if (lastName.isEmpty) {
    bytes = (await File(childImagePath).readAsBytes());
    body = json.encode({
      'FirstName': firstName,
      'ParentName': parentName,
      'ContactNumber': contactNumber,
      'Picture': bytes,
    });
  }
  else if (childImagePath == null)
    body = json.encode({
      'FirstName': firstName,
      'LastName': lastName,
      'ParentName': parentName,
      'ContactNumber': contactNumber,
    });
  else
    {
      bytes = (await File(childImagePath).readAsBytes());
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'ParentName': parentName,
        'ContactNumber': contactNumber,
        //'Bus': { 'Id': '$busId' },
        'Picture': bytes,
      });
    }



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