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
  return DateTime.now().difference(child.birthday).inDays ~/ 365.25;
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
  date = date.split('T')[0];
  date = date.split(' ')[0];

  formattedDate = date.split('-')[1] + '-' + date.split('-')[2] + '-' + date.split('-')[0];

  return formattedDate;
}

String formatNumber (String number)
{
  print(number);
  String formattedNumber = "";
  for (int i=0; i<10; i++)
  {
    if (i == 0)
      formattedNumber += '(' + number[i];
    else if (i == 2)
      formattedNumber += number[i] + ') ';
    else if (i == 5)
      formattedNumber += number[i] + '-';
    else
      formattedNumber += number[i];
  }
  return formattedNumber;
}