import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/Class.dart';

Future<List<Class>> RetrieveClasses (String token) async {

  var mUrl = "https://www.operation-portal.com/api/class-list";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadClasses mPost = ReadClasses.fromJson(json.decode(response.body));

    return mPost.classes;

  } else {

    return null;
  }
}

class ReadClasses {

  List<Class> classes;

  ReadClasses({this.classes});

  factory ReadClasses.fromJson(Map<String, dynamic> json) {
    return ReadClasses(
      classes: (json['classes'] != null) ? (json['classes'].map<Class>((value) => new Class.fromJson(value)).toList()) : (List<Class>()),
    );
  }
}