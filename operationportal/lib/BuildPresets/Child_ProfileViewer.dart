import 'package:flutter/material.dart';

Widget buildPictureNameRow_Child(String title) {
  return Container(
    child: IntrinsicHeight(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>
          [
            Container(
              child: Image(
                  image: AssetImage('assets/OCC_LOGO_128_128.png')
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                    new Radius.circular(20)
                ),
              ),
              height: 200,
              width: 200,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 10),
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28),
              ),
            ),
          ]
      ),
    ),
    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
  );
}

DateTime parseBirthday (String birthday)
{
  List<String> dateBreak = new List<String>();
  dateBreak = birthday.split('/');
  return DateTime(int.parse(dateBreak[2]), int.parse(dateBreak[0]), int.parse(dateBreak[1]));
}

int calculateBirthday(String birthday)
{
  return (DateTime.now().difference(parseBirthday(birthday.split(' ')[0])).inDays ~/ 365.25);
}

Widget buildBirthdayAndGradeRow (String birthday, int grade)
{
  return Container(
    child: IntrinsicHeight(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>
          [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Age",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    child: Text(
                      birthday != null && birthday.isNotEmpty ? '${calculateBirthday(birthday)}' : "N/A",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(right: 20),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Birthday",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    child: Text(
                      birthday != null && birthday.isNotEmpty ? birthday.split(' ')[0] : "N/A",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(right: 20),
            ),
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Grade",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        grade != null ? '$grade' : "N/A",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
            ),
          ]
      ),
    ),
    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
  );
}