class Volunteer {
  String firstName;
  String lastName;

  Volunteer({this.firstName, this.lastName});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}