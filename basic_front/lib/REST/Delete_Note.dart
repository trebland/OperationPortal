import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<void> DeleteNote (String token, int id, BuildContext context)
async {
  final url = Uri.parse("https://www.operation-portal.com/api/note");

  final request = http.Request("DELETE", url);

  request.headers.addAll(<String, String>{
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  });
  request.body = jsonEncode({"id": id});

  final response = await request.send();

  if (response.statusCode != 200)
    return null;
  else
    {
      Fluttertoast.showToast(
          msg: "Note Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pop(context);
    }
}