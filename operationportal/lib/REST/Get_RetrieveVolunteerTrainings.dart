import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/Training.dart';

Future<List<Training>> GetTrainings (String token)
async {
  var mUrl = "https://www.operation-portal.com/api/volunteer-trainings";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadTrainings mGet = ReadTrainings.fromJson(json.decode(response.body));

    return mGet.trainings;

  } else {

    return null;
  }
}

class ReadTrainings {
  List<Training> trainings;

  ReadTrainings({this.trainings});

  factory ReadTrainings.fromJson(Map<String, dynamic> json) {
    return ReadTrainings(
      trainings: json['trainings'] != null
          ? json['trainings'].map<Training>((value) => new Training.fromJson(value)).toList()
          : List<Training>(),
    );
  }
}