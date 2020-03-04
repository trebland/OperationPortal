import 'Profile.dart';

class User {
  Profile profile;
  bool checkedIn;

  User({this.profile, this.checkedIn});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      checkedIn: json['checkedIn'] != null ? json['checkedIn'] : true,
    );
  }
}