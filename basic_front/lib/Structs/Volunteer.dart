import 'Bus.dart';
import 'Class.dart';
import 'Profile.dart';

class Volunteer {
  String firstName;
  String lastName;
  Class mClass;
  Bus mBus;


  Volunteer({this.firstName, this.lastName, this.mClass, this.mBus});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      firstName: json['firstName'],
      lastName: json['lastName'],
      mClass: Class.fromJson(json['class']),
      mBus: Bus.fromJson(json['bus']),
    );
  }
}