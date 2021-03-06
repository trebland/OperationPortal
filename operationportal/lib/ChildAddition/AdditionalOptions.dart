import 'package:flutter/material.dart';
import 'package:operationportal/REST/Get_RetrieveBuses.dart';
import 'package:operationportal/REST/Post_CreateChildFull.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Storage.dart';



class AdditionalOptionsPage extends StatefulWidget {
  AdditionalOptionsPage({Key key, this.firstName, this.lastName,
    this.parentName, this.contactNumber, this.busId, this.imagePath}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String firstName;
  final String lastName;
  final String parentName;
  final String contactNumber;
  final String busId;
  final String imagePath;

  @override
  AdditionalOptionsState createState() => AdditionalOptionsState();
}

enum Gender { male, female, other}


class AdditionalOptionsState extends State<AdditionalOptionsPage> {


  final genderController = new TextEditingController();
  final birthdayController = new TextEditingController();
  final preferredNameController = new TextEditingController();

  DateTime selectedDate;
  int currentYear;
  int previousYears;

  Storage storage;

  String busDropdownValue;

  Gender _gender;

  List<String> busIds = new List<String>();

  List<String> RetrieveBusIds (List<Bus> buses)
  {
    List<String> tempList = new List<String>();
    tempList.add("Select Bus");
    for (Bus b in buses)
      {
        tempList.add('${b.id}');
      }
    return tempList;
  }

  @override
  void initState() {
    storage = new Storage();
    currentYear = DateTime.now().year;
    previousYears = currentYear - 100;

    selectedDate = DateTime.now();
    busDropdownValue = "Select Bus";
    super.initState();
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
                      color: primaryWidgetColor,
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
                      textCapitalization: TextCapitalization.words,
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
                      color: primaryWidgetColor,
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
          child: RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Birthday', style: TextStyle(color: textComplementColor)),
            color: primaryWidgetColor,
          ),
        ),
      ],
    );
  }

  Widget buildPreferredNameColumn ()
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
                      color: primaryWidgetColor,
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
                      textCapitalization: TextCapitalization.words,
                      controller: preferredNameController,
                      decoration: new InputDecoration(
                        labelText: "Preferred Name",
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
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.only(top: 25, left: 25, right: 25),
        ),
      ],
    );
  }

  Widget buildButtonBar (BuildContext context)
  {
    return ButtonBar(
      children: <Widget>[
        OutlineButton(
          child: Text('Previous', style: TextStyle(color: primaryColor),),
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
              CreateChildFull(value, widget.firstName, widget.lastName, widget.parentName, widget.contactNumber,
                  widget.busId, widget.imagePath, birthdayController.text, genderController.text, preferredNameController.text,
                  context);
            });
          },
          color: primaryColor,
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
                  buildPreferredNameColumn(),
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