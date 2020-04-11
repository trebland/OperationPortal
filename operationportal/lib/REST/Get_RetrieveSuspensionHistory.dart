import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/RosterChild.dart';
import 'package:operationportal/Structs/Suspension.dart';

Future<List<Suspension>> GetSuspensions (String token, String id)
async {
  var mUrl = "https://www.operation-portal.com/api/suspension-history-child?id=$id";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadSuspensions mGet = ReadSuspensions.fromJson(json.decode(response.body));

    return mGet.suspensions;

  } else {

    return null;
  }
}

class ReadSuspensions {
  List<Suspension> suspensions;

  ReadSuspensions({this.suspensions});

  factory ReadSuspensions.fromJson(Map<String, dynamic> json) {
    return ReadSuspensions(
      suspensions: json['suspensions'] != null
          ? json['suspensions'].map<Suspension>((value) => new Suspension.fromJson(value)).toList()
          : List<Suspension>(),
    );
  }
}