class Profile {
  int id;
  String firstName;
  String lastName;
  String role;

  Profile ({this.id, this.firstName, this.lastName, this.role});

  factory Profile.fromJson (Map<String, dynamic> json)
  {
    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
    );
  }
}