import 'package:operationportal/Structs/RosterChild.dart';

// Birthday Calculations
DateTime parseBirthday (String birthday)
{
  List<String> dateBreak = new List<String>();
  dateBreak = birthday.split('/');
  return DateTime(int.parse(dateBreak[2]), int.parse(dateBreak[0]), int.parse(dateBreak[1]));
}

int calculateBirthday(RosterChild child)
{
  return DateTime.now().difference(parseBirthday(child.birthday.split(' ')[0])).inDays ~/ 365.25;
}