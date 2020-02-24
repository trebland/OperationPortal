import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:basic_front/Structs/Child.dart';

Future<ReadChildren> RetrieveRoster (String token, String busId) async {
  int adjBusId = int.parse(busId);

  var mUrl = "https://www.operation-portal.com/api/roster" + "?busId=" + '$adjBusId';


  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var queryParameters = {
    'busId': '$adjBusId',
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadChildren mPost = ReadChildren.fromJson(json.decode(response.body));

    return mPost;

  } else {

    return null;
  }
}

class ReadChildren {

  List<Child> children;

  ReadChildren({this.children});

  factory ReadChildren.fromJson(Map<String, dynamic> json) {
    return ReadChildren(
      children: json['busRoster'].map<Child>((value) => new Child.fromJson(value)).toList(),
    );
  }
}