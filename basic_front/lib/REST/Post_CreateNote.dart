import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> EditNotes (String token, int id, String notes)
async {
  var mUrl = "https://www.operation-portal.com/api/notes-edit";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var body = json.encode({
    'id': id,
    'notes': notes,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: headers);

  if (response.statusCode == 200) {

    NotesEditResponse mPost = NotesEditResponse.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.notes,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

  } else {

    return null;
  }
}

class NotesEditResponse {
  String notes;

  NotesEditResponse({this.notes});

  factory NotesEditResponse.fromJson(Map<String, dynamic> json) {
    return NotesEditResponse(
      notes: json['notes'],
    );
  }
}