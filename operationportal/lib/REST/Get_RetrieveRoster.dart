import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/RosterChild.dart';

Future<List<RosterChild>> RetrieveRoster (String token, String busId, String classId) async {

  int adjBusId;
  int adjClassId;
  bool readFullRoster = false;


  if (busId == "Select Route" || busId.isEmpty)
    adjBusId = 0;
  else
    adjBusId = int.parse(busId);

  if (classId == "Select Class" || classId.isEmpty)
    adjClassId = 0;
  else
    adjClassId = int.parse(classId);

  var mUrl;

  if (adjBusId == 0 && adjClassId == 0)
    {
      mUrl = "https://www.operation-portal.com/api/roster";
      readFullRoster = true;
    }
  else
    mUrl = "https://www.operation-portal.com/api/roster" + "?busId=" + '$adjBusId' + "&classId=" + '$adjClassId';

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
        if (readFullRoster)
          {
            ReadFullChildren mPost = ReadFullChildren.fromJson(json.decode(response.body));

            return mPost.fullChildren;
          }
        else
          {
            ReadChildren mPost = ReadChildren.fromJson(json.decode(response.body));

            if (mPost.intersectedChildren == null)
              if (mPost.busChildren == null)
                return mPost.classChildren;
              else
                return mPost.busChildren;

            return mPost.intersectedChildren;
          }

  } else {

    return null;
  }
}

class ReadChildren {

  List<RosterChild> busChildren;
  List<RosterChild> classChildren;
  List<RosterChild> intersectedChildren;

  ReadChildren({this.busChildren, this.classChildren, this.intersectedChildren,});

  factory ReadChildren.fromJson(Map<String, dynamic> json) {
    return ReadChildren(
      busChildren: json['busRoster'] != null
          ? json['busRoster'].map<RosterChild>((value) =>
      new RosterChild.fromJson(value)).toList()
          : null,
      classChildren: json['classRoster'] != null
          ? json['classRoster'].map<
          RosterChild>((value) => new RosterChild.fromJson(value)).toList()
          : null,
      intersectedChildren: json['intersectionRoster'] != null
          ? json['intersectionRoster'].map<RosterChild>((
          value) => new RosterChild.fromJson(value)).toList()
          : null,
    );
  }
}

class ReadFullChildren {
  List<RosterChild> fullChildren;

  ReadFullChildren({this.fullChildren});

  factory ReadFullChildren.fromJson(Map<String, dynamic> json) {
    return ReadFullChildren(
      fullChildren: json['fullRoster'] != null
          ? json['fullRoster'].map<
          RosterChild>((value) => new RosterChild.fromJson(value)).toList()
          : null,
    );
  }
}