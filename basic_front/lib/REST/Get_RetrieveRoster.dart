import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:basic_front/Structs/Child.dart';

Future<List<Child>> RetrieveRoster (String token, String busId, String classId) async {

  int adjBusId;
  int adjClassId;


  if (busId == "Select Route")
    adjBusId = 0;
  else
    adjBusId = int.parse(busId);

  if (classId == "Select Class")
    adjClassId = 0;
  else
    adjClassId = int.parse(classId);

  if (adjBusId == 0 && adjClassId == 0)
    throw Exception('No Route or Class Selected');

  var mUrl = "https://www.operation-portal.com/api/roster" + "?busId=" + '$adjBusId' + "&classId=" + '$adjClassId';

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

    List<Child> children = new List<Child>();

    if (mPost.busChildren != null)
      for (Child c in mPost.busChildren)
        children.add(c);

    if (mPost.classChildren != null)
      for (Child c in mPost.classChildren)
        children.add(c);

    return children;

  } else {

    return null;
  }
}

class ReadChildren {

  List<Child> busChildren;
  List<Child> classChildren;

  ReadChildren({this.busChildren, this.classChildren});

  factory ReadChildren.fromJson(Map<String, dynamic> json) {
    return ReadChildren(
      busChildren: json['busRoster'] != null ? json['busRoster'].map<Child>((value) => new Child.fromJson(value)).toList() : null,
      classChildren: json['classRoster'] != null ? json['classRoster'].map<Child>((value) => new Child.fromJson(value)).toList() : null,
    );
  }
}