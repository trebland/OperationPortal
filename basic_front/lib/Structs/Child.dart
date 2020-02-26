import 'Bus.dart';
import 'Class.dart';

class Child {
  int id;
  String firstName;
  String lastName;
  int grade;
  String gender;
  Class mClass;
  Bus mBus;
  String birthday;
  DateTime startSuspension;
  DateTime endSuspension;
  bool isSuspended;


  Child({this.id, this.firstName, this.lastName,
    this.grade, this.gender, this.mClass, this.mBus, this.birthday, this.startSuspension, this.endSuspension, this.isSuspended});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      grade: json['grade'],
      gender: json['gender'],
      mClass: Class.fromJson(json['class']),
      mBus: Bus.fromJson(json['bus']),
      birthday: json['birthday'],
      startSuspension: json['suspendedStart'] == null ? null : json['suspendedStart'],
      endSuspension: json['suspendedEnd'] == null ? null : json['suspendedEnd'],
      isSuspended: json['isSuspended'],
    );
  }
}