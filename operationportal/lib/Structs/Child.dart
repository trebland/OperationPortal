import 'dart:typed_data';

import 'Bus.dart';
import 'Class.dart';



class Child {

  int id;
  String firstName;
  String lastName;
  String preferredName;
  String contactNumber;
  String parentName;
  int busId;
  int classId;
  String birthday;
  String gender;
  int grade;
  bool parentalWaiver;
  bool busWaiver;
  bool haircutWaiver;
  bool parentalEmailOptIn;
  String picture;


  Child({this.id, this.firstName, this.lastName, this.preferredName,
    this.contactNumber, this.parentName, this.busId, this.classId,
    this.grade, this.gender, this.birthday, this.picture,
    this.parentalWaiver, this.busWaiver, this.haircutWaiver, this.parentalEmailOptIn});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      preferredName: json['preferredName'],
      contactNumber: json['contactNumber'],
      parentName: json['parentName'],
      busId: json['busId'],
      classId: json['classId'],
      grade: json['grade'],
      gender: json['gender'],
      birthday: json['birthday'],
      picture: json['picture'],
      parentalWaiver: json['parentalWaiver'],
      busWaiver: json['busWaiver'],
      haircutWaiver: json['haircutWaiver'],
      parentalEmailOptIn: json['parentalEmailOptIn'],
    );
  }
}