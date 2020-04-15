import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Class.dart';

class Suspension {
  DateTime startSuspension;
  DateTime endSuspension;

  Suspension({this.startSuspension, this.endSuspension});

  factory Suspension.fromJson(Map<String, dynamic> json) {
    return Suspension(
      startSuspension: json['suspendedStart'] != null ?
      new DateTime(int.parse(json['suspendedStart'].split('-')[0]),
          int.parse(json['suspendedStart'].split('-')[1]),
          int.parse(json['suspendedStart'].split('-')[2].split('T')[0])) : null,

      endSuspension: json['suspendedEnd'] != null ?
      new DateTime(int.parse(json['suspendedEnd'].split('-')[0]),
          int.parse(json['suspendedEnd'].split('-')[1]),
          int.parse(json['suspendedEnd'].split('-')[2].split('T')[0])) : null,
    );
  }
}