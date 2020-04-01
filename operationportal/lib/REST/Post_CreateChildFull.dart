import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> CreateChildFull (String token, String firstName, String lastName, String parentName,
    String contactNumber, String childImagePath, String birthday, String gender,
    String preferredName, String busId, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";

  Uint8List bytes = (await File(childImagePath).readAsBytes());
  var body;

  Map<String, dynamic> bodyToSet = {
    'FirstName': firstName,
    'LastName': lastName,
    'ParentName': parentName,
    'ContactNumber': contactNumber,
    'Picture': bytes,
  };

  if (birthday.isNotEmpty)
    {
      Map<String, dynamic> addTo = {
        'Birthday': birthday
      };
      bodyToSet.addAll(addTo);
    }

  if (gender.isNotEmpty)
    {
      Map<String, dynamic> addTo = {
        'Gender': gender
      };
      bodyToSet.addAll(addTo);
    }

  if (preferredName.isNotEmpty)
    {
      Map<String, dynamic> addTo = {
        'PreferredName': preferredName
      };
      bodyToSet.addAll(addTo);
    }

  if (busId.isNotEmpty)
    {
      Map<String, dynamic> addTo = {
        'BusId': busId,
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

    Navigator.popUntil(context, (route) => route.isFirst);
  } else {

    CreateChild_Failure mPost = CreateChild_Failure.fromJson(json.decode(response.body));

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