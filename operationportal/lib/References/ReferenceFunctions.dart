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

List<RosterChild> sortedChildren (List<RosterChild> children)
{
  List<RosterChild> oldChildren = new List<RosterChild>();
  List<RosterChild> recentChildren = new List<RosterChild>();
  for (RosterChild c in children)
  {
    c.lastDateAttended.difference(DateTime.now()).inDays > 90 ? oldChildren.add(c) : recentChildren.add(c);
  }

  recentChildren.sort((a, b) {
    return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
  });

  oldChildren.sort((a, b) {
    return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
  });

  recentChildren.addAll(oldChildren);

  return recentChildren;
}

String formatDate(String date)
{
  String formattedDate = "";
  formattedDate = date.split('-')[1] + '-' + date.split('-')[2] + '-' + date.split('-')[0];

  return formattedDate;
}