class SuspendedChild {
  int id;
  String firstName;
  String lastName;
  String startSuspension;
  String endSuspension;


  SuspendedChild({this.id, this.firstName, this.lastName,
    this.startSuspension, this.endSuspension});

  factory SuspendedChild.fromJson(Map<String, dynamic> json) {
    return SuspendedChild(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      startSuspension: json['suspendedStart'] == null ? null : json['suspendedStart'],
      endSuspension: json['suspendedEnd'] == null ? null : json['suspendedEnd'],
    );
  }
}