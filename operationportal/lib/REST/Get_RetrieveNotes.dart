import 'dart:convert';

import 'package:operationportal/Structs/Note.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/RosterChild.dart';

Future<List<Note>> RetrieveNotes (String token, int childId) async {


  var mUrl = "https://www.operation-portal.com/api/notes" + "?id=" + '$childId';

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadNotes mPost = ReadNotes.fromJson(json.decode(response.body));

    return mPost.notes;

  } else {

    return null;
  }
}

class ReadNotes {

  List<Note> notes;

  ReadNotes({this.notes});

  factory ReadNotes.fromJson(Map<String, dynamic> json) {
    return ReadNotes(
      notes: (json['notes'] != null) ? (json['notes'].map<Note>((value) => new Note.fromJson(value)).toList()) : (List<Note>()),
    );
  }
}