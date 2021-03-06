import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/Volunteer.dart';


Future<List<Volunteer>> RetrieveVolunteers (String token, String currentDay, bool checkedIn)
async {
  var mUrl;

  if (!checkedIn)
    mUrl = "https://www.operation-portal.com/api/volunteers-for-day?day=$currentDay&CheckedIn=$checkedIn&SignedUp=true";
  else
    mUrl = "https://www.operation-portal.com/api/volunteers-for-day?day=$currentDay&CheckedIn=$checkedIn";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadVolunteers mPost = ReadVolunteers.fromJson(json.decode(response.body));

    return mPost.volunteers;

  } else {

    return null;
  }
}

class ReadVolunteers {
  List<Volunteer> volunteers;

  ReadVolunteers({this.volunteers});

  factory ReadVolunteers.fromJson(Map<String, dynamic> json) {
    return ReadVolunteers(
      volunteers: (json['volunteers'] != null) ? (json['volunteers'].map<Volunteer>((value) => new Volunteer.fromJson(value)).toList()) : (List<Volunteer>()),
    );
  }
}