import 'Bus.dart';
import 'Class.dart';
import 'Profile.dart';

class User {
  Profile profile;
  bool checkedIn;
  bool isTeacher;

  List<Class> classes;
  List<Bus> buses;

  User({this.profile, this.checkedIn, this.isTeacher,
  this.classes, this.buses});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      checkedIn: json['checkedIn'] != null ? json['checkedIn'] : true,
      isTeacher: json['isTeacher'] != null ? json['isTeacher'] : true,
      classes: (json['classes'] != null) ? (json['classes'].map<Class>((value) => new Class.fromJson(value)).toList()) : (List<Class>()),
      buses: (json['buses'] != null) ? (json['buses'].map<Bus>((value) => new Bus.fromJson(value)).toList()) : (List<Bus>()),
    );
  }
}