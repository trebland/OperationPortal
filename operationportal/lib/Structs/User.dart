
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';
import 'package:operationportal/Structs/Profile.dart';

class User {
  Profile profile;
  bool checkedIn;
  bool isTeacher;

  List<Class> classes;
  List<Bus> buses;

  User({this.profile, this.checkedIn, this.isTeacher,
  this.classes, this.buses});

  factory User.fromJson(Map<String, dynamic> json) {
    List<Class> mClasses = (json['classes'] != null) ? (json['classes'].map<Class>((value) => new Class.fromJson(value)).toList()) : (List<Class>());
    return User(
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      checkedIn: json['checkedIn'] != null ? json['checkedIn'] : false,
      classes: mClasses,
      isTeacher: json['isTeacher'] != null ? json['isTeacher'] : (mClasses.length > 0 ? true : false),
      buses: (json['buses'] != null) ? (json['buses'].map<Bus>((value) => new Bus.fromJson(value)).toList()) : (List<Bus>()),
    );
  }
}