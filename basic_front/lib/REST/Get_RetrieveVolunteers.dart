import 'dart:convert';

import 'package:basic_front/Structs/Volunteer.dart';
import 'package:http/http.dart' as http;


Future<ReadVolunteers> GetVolunteers (String token, String currentDay)
async {

  var mUrl = "https://www.operation-portal.com/api/volunteers-for-day" + "?Day=" + currentDay;


  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var queryParameters = {
    'Day': currentDay,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadVolunteers mPost = ReadVolunteers.fromJson(json.decode(response.body));

    return mPost;

  } else {

    return null;
  }
}

class ReadVolunteers {
  List<Volunteer> volunteers;

  ReadVolunteers({this.volunteers});

  factory ReadVolunteers.fromJson(Map<String, dynamic> json) {
    return ReadVolunteers(
      volunteers: json['busRoster'].map<Volunteer>((value) => new Volunteer.fromJson(value)).toList(),
    );
  }
}