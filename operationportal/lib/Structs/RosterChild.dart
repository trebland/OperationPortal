import 'Bus.dart';
import 'Class.dart';

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
  String birthday;
  String picture;
  String startSuspension;
  String endSuspension;
  bool isSuspended;
  bool isCheckedIn;


  RosterChild({this.id, this.firstName, this.lastName, this.preferredName, this.parentName,
    this.contactNumber, this.grade, this.gender, this.mClass, this.mBus, this.birthday, this.picture,
    this.startSuspension, this.endSuspension, this.isSuspended, this.isCheckedIn});

  factory RosterChild.fromJson(Map<String, dynamic> json) {
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
      birthday: json['birthday'],
      picture: json['picture'],
      startSuspension: json['suspendedStart'] == null ? null : json['suspendedStart'],
      endSuspension: json['suspendedEnd'] == null ? null : json['suspendedEnd'],
      isSuspended: json['isSuspended'],
      isCheckedIn: json['isCheckedIn'],
    );
  }
}