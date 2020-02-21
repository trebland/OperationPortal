import 'dart:convert';

import 'package:basic_front/Structs/Volunteer.dart';
import 'package:http/http.dart' as http;

Future<ReadVolunteers> GetVolunteers (String token, DateTime currentDay)
{

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