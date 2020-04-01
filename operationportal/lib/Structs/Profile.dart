class Profile {
  int id;
  String firstName;
  String lastName;
  String preferredName;
  int weeksAttended;
  String role;
  String phone;
  String email;
  bool orientation;
  String picture;
  bool canEditInventory;

//  "id": 7,
//  "firstName": "Test",
//  "lastName": "Staff",
//  "preferredName": "Test",
//  "weeksAttended": 0,
//  "role": "Staff",
//  "phone": "",
//  "email": "staff@occ.com",
//  "orientation": false,
//  "trainings": [],
//  "affiliation": "",
//  "referral": "",
//  "languages": [],
//  "classesInterested": null,
//  "agesInterested": null,
//  "newsletter": false,
//  "contactWhenShort": false,
//  "backgroundCheck": false,
//  "blueShirt": false,
//  "nameTag": false,
//  "personalInterviewCompleted": false,
//  "yearStarted": 2020,
//  "canEditInventory": false,
//  "birthday": "1969-01-01T00:00:00",
//  "picture": null,
//  "bus": null,
//  "class": null

  Profile ({this.id, this.firstName, this.lastName, this.preferredName, this.weeksAttended,
    this.role, this.phone, this.email, this.orientation, this.picture,
    this.canEditInventory});

  factory Profile.fromJson (Map<String, dynamic> json)
  {
    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      preferredName: json['preferredName'],
      weeksAttended: json['weeksAttended'],
      role: json['role'],
      phone: json['phone'],
      email: json['email'],
      orientation: json['orientation'],
      picture: json['picture'],
      canEditInventory: json['canEditInventory'],
    );
  }
}