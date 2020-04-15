

import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';

class RosterChild {
  int id;
  String firstName;
  String lastName;
  String preferredName;
  String parentName;
  String contactNumber;
  int grade;
  String gender;
  Class mClass;
  Bus mBus;
  DateTime birthday;
  String picture;
  String startSuspension;
  String endSuspension;
  bool isSuspended;
  bool isCheckedIn;
  DateTime lastDateAttended;



  RosterChild({this.id, this.firstName, this.lastName, this.preferredName, this.parentName,
    this.contactNumber, this.grade, this.gender, this.mClass, this.mBus, this.birthday, this.picture,
    this.startSuspension, this.endSuspension, this.isSuspended, this.isCheckedIn,
    this.lastDateAttended});

  factory RosterChild.fromJson(Map<String, dynamic> json) {
    bool isBirthdayNotEmpty (String birthday)
    {
      return birthday.isNotEmpty ? true : false;
    }
    return RosterChild(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      preferredName: json['preferredName'],
      parentName: json['parentName'],
      contactNumber: json['contactNumber'],
      grade: json['grade'],
      gender: json['gender'],
      mClass: Class.fromJson(json['class']),
      mBus: Bus.fromJson(json['bus']),
      //4/15/2008 12:00:00 AM
      birthday: (json['birthday'] != null && isBirthdayNotEmpty(json['birthday']) ) ?
      new DateTime(int.parse(json['birthday'].split('/')[2].split(' ')[0]),
        int.parse(json['birthday'].split('/')[0]),
        int.parse(json['birthday'].split('/')[1]),) : null,
      picture: json['picture'],
      startSuspension: json['suspendedStart'] == null ? null : json['suspendedStart'],
      endSuspension: json['suspendedEnd'] == null ? null : json['suspendedEnd'],
      isSuspended: json['isSuspended'],
      isCheckedIn: json['isCheckedIn'] != null ? json['isCheckedIn'] : false,
      lastDateAttended: json['lastDateAttended'] != null ?
        new DateTime(int.parse(json['lastDateAttended'].split('-')[0]),
          int.parse(json['lastDateAttended'].split('-')[1]),
          int.parse(json['lastDateAttended'].split('-')[2].split('T')[0])) : null,
    );
  }
}