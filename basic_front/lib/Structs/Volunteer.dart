import 'Profile.dart';

class Volunteer {
  Profile profile;
  bool checkedIn;

  Volunteer({this.profile, this.checkedIn});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      checkedIn: json['checkedIn'],
    );
  }
}