import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';

import 'Training.dart';

class Profile {
  int id;
  String firstName;
  String lastName;
  String preferredName;
  String role;
  String email;
  String phone;
  DateTime birthday;
  Class mClass;
  Bus mBus;

  List<Training> trainings;
  List<String> languages;
  int yearStarted;
  int weeksAttended;

  String affiliation;
  String referral;
  String picture;
  bool canEditInventory;
  bool orientation;
  bool newsletter;
  bool contactWhenShort;
  bool blueShirt;
  bool nameTag;
  bool personalInterviewCompleted;
  bool backgroundCheck;

  Profile({this.id, this.firstName, this.lastName, this.preferredName, this.email, this.phone,
    this.role, this.weeksAttended, this.canEditInventory, this.birthday, this.mClass, this.mBus,
    this.trainings, this.languages, this.yearStarted, this.affiliation, this.referral, this.picture,
    this.orientation, this.newsletter, this.contactWhenShort, this.blueShirt, this.nameTag,
    this.personalInterviewCompleted, this.backgroundCheck});



  factory Profile.fromJson(Map<String, dynamic> json) {

    List<String> cleanLanguages(List<String> toClean)
    {
      List<String> cleaned = new List<String>();
      for (String s in toClean)
        cleaned.add(s);
      return cleaned;
    }

    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      preferredName: json['preferredName'],
      role: json['role'],
      weeksAttended: json['weeksAttended'],
      canEditInventory: json['canEditInventory'],
      email: json['email'],
      birthday: json['birthday'] != null ?
      new DateTime(int.parse(json['birthday'].split('-')[0]),
          int.parse(json['birthday'].split('-')[1]),
          int.parse(json['birthday'].split('-')[2].split('T')[0])) : null,
      phone: json['phone'],
      mClass: json['class'] != null ? Class.fromJson(json['class']) : null,
      mBus: json['bus'] != null ? Bus.fromJson(json['bus']) : null,
      trainings: json['trainings'] != null ? json['trainings'].map<Training>((value) => new Training.fromJson(value)).toList() : null,
      languages: json['languages'] != null ? cleanLanguages(json['languages'].cast<String>()) : null,
      yearStarted: json['yearStarted'],
      affiliation: json['affiliation'],
      referral: json['referral'],
      picture: json['picture'],
      orientation: json['orientation'],
      newsletter: json['newsletter'],
      contactWhenShort: json['contactWhenShort'],
      blueShirt: json['blueShirt'],
      nameTag: json['nameTag'],
      personalInterviewCompleted: json['personalInterviewCompleted'],
      backgroundCheck: json['backgroundCheck'],
    );
  }
}