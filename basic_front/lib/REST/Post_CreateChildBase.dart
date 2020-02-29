import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> CreateChildBase (String token, String firstName, String lastName, int classId, int busId, String childImagePath, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";

  Uint8List bytes = (await File(childImagePath).readAsBytes());
  print(await File(childImagePath).readAsBytes());
  // Image image = await decodeImageFromList(bytes);

  var body = json.encode({
    'FirstName': firstName,
    'LastName': lastName,
    'Class': { 'Id': '$classId' },
    'Bus': { 'Id': '$busId' },
    'Picture': bytes,
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