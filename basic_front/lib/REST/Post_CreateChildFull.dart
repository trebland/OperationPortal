import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> CreateChildFull (String token, String firstName, String lastName, int classId, int busId, String gender, String grade, String birthday, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";

  // Implement Changes
  int gradeAdj;

  bool addGender = true;
  bool addGrade = true;
  bool addBirthday = true;

  if (gender == "")
    addGender = false;

  if (grade == "")
    addGrade = false;
  else
    gradeAdj = int.parse(grade);

  if (birthday == "")
    addBirthday = false;

  var body;

  if (!addGender)
    if (!addGrade)
      if(!addBirthday)
        body = json.encode({
          'FirstName': firstName,
          'LastName': lastName,
          'Class': { 'Id': '$classId' },
          'Bus': { 'Id': '$busId' },
        });
      else
        body = json.encode({
          'FirstName': firstName,
          'LastName': lastName,
          'Class': { 'Id': '$classId' },
          'Bus': { 'Id': '$busId' },
          'Birthday': birthday,
        });
    else if (!addBirthday)
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'Class': { 'Id': '$classId' },
        'Bus': { 'Id': '$busId' },
        'Grade': '$gradeAdj',
      });
    else
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'Class': { 'Id': '$classId' },
        'Bus': { 'Id': '$busId' },
        'Grade': '$gradeAdj',
        'Birthday': birthday,
      });
  else if(!addGrade)
    if(!addBirthday)
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'Class': { 'Id': '$classId' },
        'Bus': { 'Id': '$busId' },
        'Gender': gender,
      });
    else
      body = json.encode({
        'FirstName': firstName,
        'LastName': lastName,
        'Class': { 'Id': '$classId' },
        'Bus': { 'Id': '$busId' },
        'Gender': gender,
        'Birthday': birthday,
      });
  else if(!addBirthday)
    body = json.encode({
      'FirstName': firstName,
      'LastName': lastName,
      'Class': { 'Id': '$classId' },
      'Bus': { 'Id': '$busId' },
      'Gender': gender,
      'Grade': '$gradeAdj',
    });
  else
    body = json.encode({
      'FirstName': firstName,
      'LastName': lastName,
      'Class': { 'Id': '$classId' },
      'Bus': { 'Id': '$busId' },
      'Gender': gender,
      'Grade': '$gradeAdj',
      'Birthday': birthday,
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