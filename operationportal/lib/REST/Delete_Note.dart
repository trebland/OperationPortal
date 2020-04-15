import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Widget/LoadingScreen.dart';

Future<void> DeleteNote (String token, int id, BuildContext context)
async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Deleting Note",)));
  var mUrl = "https://www.operation-portal.com/api/note" + "?id=" + '$id';

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.delete(mUrl,
    headers: headers);

  if (response.statusCode == 200) {

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
    Navigator.pop(context);
  } else {
    return null;
  }
} 