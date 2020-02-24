import 'dart:convert';

import 'package:basic_front/Structs/SuspendedChild.dart';
import 'package:http/http.dart' as http;

Future<ReadSuspensions> GetSuspendedChildren (String token)
async {
  var mUrl = "https://www.operation-portal.com/api/suspensions";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadSuspensions mGet = ReadSuspensions.fromJson(json.decode(response.body));

    return mGet;

  } else {

    return null;
  }
}

class ReadSuspensions {
  List<SuspendedChild> suspended;

  ReadSuspensions({this.suspended});

  factory ReadSuspensions.fromJson(Map<String, dynamic> json) {
    return ReadSuspensions(
      suspended: json['suspensions'].map<SuspendedChild>((value) => new SuspendedChild.fromJson(value)).toList(),
    );
  }
}