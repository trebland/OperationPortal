import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Widget/LoadingScreen.dart';

Future<void> CreateNote (String token, String author, int childId, String content, String date, String priority, BuildContext context)
async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Creating Note",)));
  var mUrl = "https://www.operation-portal.com/api/note";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var body = json.encode({
    'author': author,
    'childId': childId,
    'content': content,
    'priority': priority,
    'date': date.isEmpty ? DateTime.now().toString().split('T')[0] : date,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: headers);

  if (response.statusCode == 200) {

    Fluttertoast.showToast(
        msg: "Note Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.pop(context);
    Navigator.pop(context);
  } else {

    Navigator.pop(context);
    return null;
  }
}