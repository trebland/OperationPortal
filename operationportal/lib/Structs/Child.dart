



class Child {

  int id;
  String firstName;
  String lastName;
  String preferredName;
  String contactNumber;
  String parentName;
  int busId;
  int classId;
  DateTime birthday;
  String gender;
  int grade;
  bool parentalWaiver;
  bool busWaiver;
  bool haircutWaiver;
  bool parentalEmailOptIn;
  String picture;
  bool isSuspended;
  bool isCheckedIn;


  Child({this.id, this.firstName, this.lastName, this.preferredName,
    this.contactNumber, this.parentName, this.busId, this.classId,
    this.grade, this.gender, this.birthday, this.picture,
    this.parentalWaiver, this.busWaiver, this.haircutWaiver, this.parentalEmailOptIn,
    this.isSuspended, this.isCheckedIn});

  factory Child.fromJson(Map<String, dynamic> json) {
    bool isBirthdayNotEmpty (String birthday)
    {
      return birthday.isNotEmpty ? true : false;
    }
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
      birthday: (json['birthday'] != null && isBirthdayNotEmpty(json['birthday']) ) ?
      new DateTime(int.parse(json['birthday'].split('/')[2].split(' ')[0]),
        int.parse(json['birthday'].split('/')[0]),
        int.parse(json['birthday'].split('/')[1]),) : null,
      picture: json['picture'],
      parentalWaiver: json['parentalWaiver'],
      busWaiver: json['busWaiver'],
      haircutWaiver: json['haircutWaiver'],
      parentalEmailOptIn: json['parentalEmailOptIn'],
      isSuspended: json['isSuspended'],
      isCheckedIn: json['isCheckedIn'] != null ? json['isCheckedIn'] : false,
    );
  }
}