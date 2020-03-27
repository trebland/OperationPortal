import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> CreateChildFull (String token, String firstName, String lastName, String parentName, String contactNumber, String childImagePath, String birthday, String gender, String preferredName, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";

  // Implement Changes
  int gradeAdj;

  bool addBirthday = true;
  bool addGender = true;
  bool addPreferredName = true;

  if (birthday.isEmpty)
    addGender = false;

  if (gender.isEmpty)
    addGender = false;

  if (preferredName.isEmpty)
    addPreferredName = false;


  Uint8List bytes = (await File(childImagePath).readAsBytes());
  var body;

  if (!addGender)
    if (!addBirthday)
      if(!addPreferredName)
        body = json.encode({
          'FirstName': firstName,
          'LastName': lastName,
          'ParentName': parentName,
          'ContactNumber': contactNumber,
          'Picture': bytes,
        });
      else
        body = json.encode({
          'FirstName': firstName,
          'LastName': lastName,
          'ParentName': parentName,
          'ContactNumber': contactNumber,
          'Picture': bytes,
          'PreferredName': preferredName,
        });
    else if (!addPreferredName)
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'ParentName': parentName,
        'ContactNumber': contactNumber,
        //'Bus': { 'Id': '$busId' },
        'Picture': bytes,
        'Birthday': birthday,
      });
    else
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'ParentName': parentName,
        'ContactNumber': contactNumber,
        //'Bus': { 'Id': '$busId' },
        'Picture': bytes,
        'Birthday': birthday,
        'PreferredName': preferredName,
      });
  else if(!addBirthday)
    if(!addPreferredName)
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'ParentName': parentName,
        'ContactNumber': contactNumber,
        //'Bus': { 'Id': '$busId' },
        'Picture': bytes,
        'Gender': gender,
      });
    else
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'ParentName': parentName,
        'ContactNumber': contactNumber,
        //'Bus': { 'Id': '$busId' },
        'Picture': bytes,
        'Gender': gender,
        'PreferredName': preferredName,
      });
  else if(!addPreferredName)
    body = json.encode({
      'FirstName': firstName,
      'LastName': lastName,
      'ParentName': parentName,
      'ContactNumber': contactNumber,
      //'Bus': { 'Id': '$busId' },
      'Picture': bytes,
      'Birthday': birthday,
      'Gender': gender,
    });
  else
    body = json.encode({
      'FirstName': firstName,
      'LastName': lastName,
      'ParentName': parentName,
      'ContactNumber': contactNumber,
      //'Bus': { 'Id': '$busId' },
      'Picture': bytes,
      'Birthday': birthday,
      'Gender': gender,
      'PreferredName': preferredName,
    });


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