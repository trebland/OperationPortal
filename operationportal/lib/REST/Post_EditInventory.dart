import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Widget/LoadingScreen.dart';

Future<void> EditInventory (String token, String name, int count, int id, bool resolved, BuildContext context)
async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Editing Item",)));
  var mUrl = "https://www.operation-portal.com/api/inventory-edit";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var body = json.encode({
    'name': name,
    'count': count,
    'id': id,
    'resolved': resolved,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: headers);

  if (response.statusCode == 200) {

    Fluttertoast.showToast(
        msg: "Item Edited",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  } else {

    Navigator.pop(context);
    return null;
  }
}