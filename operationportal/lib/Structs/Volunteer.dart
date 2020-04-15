

import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/Language.dart';
import 'package:operationportal/Structs/Training.dart';

class Volunteer {
  /*“volunteer”: {  “training”: [{“name”: “string”}], “referral”: “string”, “languages”: [“language”: “string”], “newsletter”: “bool”, “contactWhenShort”: “bool”, “phone”: “string”, “email”: “string”,“blueShirt”:bool, “nametag”:bool, “personalInterviewCompleted”:bool, “backgroundCheck”:bool, “yearStarted”:int, “canEditInventory”:bool, “picture”:byte[], “birthday”:DateTime}*/
  int id;
  String firstName;
  String lastName;
  String preferredName;
  Class mClass;
  Bus mBus;

  int yearStarted;
  List<Training> trainings;
  List<String> languages;

  String affiliation;
  String referral;
  String picture;
  bool orientation;

  Volunteer({this.id, this.firstName, this.lastName, this.preferredName,
    this.mClass, this.mBus, this.trainings, this.languages, this.yearStarted,
    this.affiliation, this.referral, this.picture, this.orientation});



  factory Volunteer.fromJson(Map<String, dynamic> json) {

    List<String> cleanLanguages(List<String> toClean)
    {
      List<String> cleaned = new List<String>();
      for (String s in toClean)
        cleaned.add(s);
      return cleaned;
    }

    return Volunteer(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      preferredName: json['preferredName'],
      mClass: json['class'] != null ? Class.fromJson(json['class']) : null,
      mBus: json['bus'] != null ? Bus.fromJson(json['bus']) : null,
      trainings: json['trainings'] != null ? json['trainings'].map<Training>((value) => new Training.fromJson(value)).toList() : null,
      languages: json['languages'] != null ? cleanLanguages(json['languages'].cast<String>()) : null,
      yearStarted: json['yearStarted'],
      affiliation: json['affiliation'],
      referral: json['referral'],
      picture: json['picture'],
      orientation: json['orientation'],
    );
  }
}