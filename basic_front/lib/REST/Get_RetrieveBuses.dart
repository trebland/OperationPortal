import 'dart:convert';

import 'package:basic_front/Structs/Bus.dart';
import 'package:http/http.dart' as http;

Future<List<Bus>> RetrieveBuses (String token) async {

  var mUrl = "https://www.operation-portal.com/api/bus-list";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadBuses mPost = ReadBuses.fromJson(json.decode(response.body));

    return mPost.buses;

  } else {

    return null;
  }
}

class ReadBuses {

  List<Bus> buses;

  ReadBuses({this.buses});

  factory ReadBuses.fromJson(Map<String, dynamic> json) {
    return ReadBuses(
      buses: (json['buses'] != null) ? (json['buses'].map<Bus>((value) => new Bus.fromJson(value)).toList()) : (List<Bus>()),
    );
  }
}