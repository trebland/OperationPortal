import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'Storage.dart';

class CreateChild_Failure {
  String error;

  CreateChild_Failure({this.error});

  factory CreateChild_Failure.fromJson(Map<String, dynamic> json) {
    return CreateChild_Failure(
      error: json['error'],
    );
  }
}

Future<void> CreateChild_Full (String token, String firstName, String lastName, int classId, int busId, String gender, int grade, String birthday, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/child-creation";

  var body = json.encode({
    'FirstName': firstName,
    'LastName': lastName,
    'Class': { 'Id': '$classId' },
    'Bus': { 'Id': '$busId' },
    'Gender': gender,
    'Grade': '$grade',
    'Birthday': birthday,
  });

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200)
  {
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  } else {

    CreateChild_Failure mPost = CreateChild_Failure.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    throw Exception('Failed to load post');
  }
}

class AdditionalOptionsPage extends StatefulWidget {
  AdditionalOptionsPage({Key key, this.firstName, this.lastName, this.classId, this.routeId}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String firstName;
  final String lastName;
  final int classId;
  final int routeId;

  @override
  AdditionalOptionsState createState() => AdditionalOptionsState();
}

enum SingingCharacter { lafayette, jefferson }
enum Gender { male, female, other}

class AdditionalOptionsState extends State<AdditionalOptionsPage> {

  final genderController = new TextEditingController();
  final birthdayController = new TextEditingController();
  final gradeController = new TextEditingController();

  DateTime selectedDate;
  int currentYear;
  int previousYears;

  Storage storage;

  int gradeDropdownValue;

  Gender _gender = Gender.male;

  @override
  void initState() {
    storage = new Storage();
    currentYear = DateTime.now().year;
    previousYears = currentYear - 25;

    genderController.text = "Male";
    gradeDropdownValue = 1;
    gradeController.text = '$gradeDropdownValue';

    selectedDate = DateTime.now();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(previousYears),
        lastDate: DateTime(currentYear, 12, 31));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      birthdayController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  void populateGenderController(Gender gender)
  {
    if (gender == Gender.male)
      genderController.text = "Male";
    else if(gender == Gender.female)
      genderController.text = "Female";
    else
      genderController.text = "Type Here";
  }

  bool isGenderTextFieldEnabled(Gender gender)
  {
    if (gender == Gender.other)
      return true;
    else
      return false;
  }

  Widget buildGenderColumn ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: genderController,
                      decoration: new InputDecoration(
                        labelText: "Gender",
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      enabled: isGenderTextFieldEnabled(_gender),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.only(top: 25, left: 25, right: 25),
        ),
        ListTile(
          title: const Text('Male'),
          leading: Radio(
            value: Gender.male,
            groupValue: _gender,
            onChanged: (Gender value) {
              setState(() { _gender = value; });
              populateGenderController(_gender);
            },
          ),
        ),
        ListTile(
          title: const Text('Female'),
          leading: Radio(
            value: Gender.female,
            groupValue: _gender,
            onChanged: (Gender value) {
              setState(() { _gender = value; });
              populateGenderController(_gender);
            },
          ),
        ),
        ListTile(
          title: const Text('Other'),
          leading: Radio(
            value: Gender.other,
            groupValue: _gender,
            onChanged: (Gender value) {
              setState(() { _gender = value; });
              populateGenderController(_gender);
            },
          ),
        ),
      ],
    );
  }

  Widget buildBirthdayColumn ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.cake,
                      size: 40,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: birthdayController,
                      decoration: new InputDecoration(
                        labelText: "Birthday",
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      enabled: false,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.only(top: 25, left: 25, right: 25,),
        ),
        Container(
          child: OutlineButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Birthday'),
          ),
        ),
      ],
    );
  }

  Widget buildGradeRow()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.grade,
                      size: 40,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: gradeController,
                      decoration: new InputDecoration(
                        labelText: "Grade",
                        hintText: "Grade " + '$gradeDropdownValue',
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      enabled: false,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.only(top: 25, left: 25, right: 25,),
        ),
        Container(
          child: DropdownButton<int>(
            value: gradeDropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                color: Colors.deepPurple
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int newValue) {
              setState(() {
                gradeDropdownValue = newValue;
              });
              gradeController.text = '$gradeDropdownValue';
            },
            items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              );
            })
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget buildButtonBar (BuildContext context)
  {
    return ButtonBar(
      children: <Widget>[
        OutlineButton(
          child: Text('Previous', style: TextStyle(color: Colors.deepPurple),),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: const Text('Add Child'),
          onPressed: ()
          {
            storage.readToken().then((value) {
              CreateChild_Full(value, widget.firstName, widget.lastName, widget.classId, widget.routeId, genderController.text, int.parse(gradeController.text), birthdayController.text, context);
            });
          },
          color: Colors.amber,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text('Additional Options'),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildBirthdayColumn(),
                  buildGenderColumn(),
                  buildGradeRow(),
                  buildButtonBar(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}