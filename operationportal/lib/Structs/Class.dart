class Class {
  int id;
  String name;
  // Staff vars
  int numStudents;
  int teacherId;
  String teacherName;
  String location;

  Class({this.id, this.name,
  this.numStudents, this.teacherId, this.teacherName, this.location});

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      name: json['name'],
      numStudents: json['numStudents'],
      teacherId: json['teacherId'],
      teacherName: json['teacherName'] != null ? json['teacherName'] : "N/A",
      location: json['location'] != null ? json['location'] : "N/A",
    );
  }
}