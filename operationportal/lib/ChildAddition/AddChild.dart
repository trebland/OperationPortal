import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:operationportal/ChildAddition/AdditionalOptions.dart';
import 'package:operationportal/REST/Get_RetrieveBuses.dart';
import 'package:operationportal/REST/Post_CreateChildBase.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Bus.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Widget/TakePicture.dart';


class AddChildPage extends StatefulWidget {
  AddChildPage({Key key, this.futureBuses, this.driversBus}) : super(key: key);

  Future<List<Bus>> futureBuses;
  final Bus driversBus;

  @override
  AddChildState createState() => AddChildState();
}

class AddChildState extends State<AddChildPage>
{

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final parentNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final busController = new TextEditingController();

  final _phoneFormatter = _UsNumberTextInputFormatter();

  Storage storage;
  String childImagePath;

  int busIndex;



  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      childImagePath = image.path;
    });
  }

  Future<void> checkTakePictureResponse () async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;


    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PicturePage(camera: firstCamera,)),
    );

    childImagePath = result;
    print(File(childImagePath).readAsBytesSync());
    setState(() {
    });
  }

  int matchBusIds (List<Bus> listOf, Bus toMatch)
  {
    for (Bus b in listOf)
      if (b.id == toMatch.id)
        return listOf.indexOf(b);
  }

  @override
  void initState() {
     storage = new Storage();

     busIndex = 0;

     super.initState();
  }

  String parseNumber (String number)
  {
    String parsedNumber = "";
    number.runes.forEach((int rune) {
      var character=new String.fromCharCode(rune);
      if (rune < 48 || rune > 57)
      {
        character = "";
      }
      parsedNumber = parsedNumber + character;
    });
    return parsedNumber;
  }

  bool filledOut()
  {
    if (firstNameController.text.isEmpty)
      {
        Fluttertoast.showToast(
            msg: 'First Name is mandatory',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        return false;
      }
    else if (parentNameController.text.isEmpty)
      {
        Fluttertoast.showToast(
            msg: 'Parent name is mandatory',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        return false;
      }
    else if (contactNumberController.text.length != 14)
      {
        Fluttertoast.showToast(
            msg: 'Contact number is mandatory',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        return false;
      }
    else if (busController.text.isEmpty)
    {

      Fluttertoast.showToast(
          msg: 'Bus Id is mandatory',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else if (childImagePath == null)
    {
      Fluttertoast.showToast(
          msg: 'Child Image must be added later',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return true;
    }
    else
      return true;

  }

  bool additionalFilledOut()
  {
    if (firstNameController.text.isEmpty)
    {
      Fluttertoast.showToast(
          msg: 'First Name is mandatory to procede to additional options',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else if (lastNameController.text.isEmpty)
    {
      Fluttertoast.showToast(
          msg: 'Last Name is mandatory to procede to additional options',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else if (parentNameController.text.isEmpty)
    {
      Fluttertoast.showToast(
          msg: 'Parent name is mandatory to procede to additional options',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else if (contactNumberController.text.length != 14)
    {
      Fluttertoast.showToast(
          msg: 'Contact number is mandatory to procede to additional options',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else if (busController.text.isEmpty)
    {

      Fluttertoast.showToast(
          msg: 'Bus Id is mandatory to procede to additional options',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else if (childImagePath == null)
    {
      Fluttertoast.showToast(
          msg: 'Child Image is mandatory to procede to additional options',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }
    else
      return true;

  }

  Widget buildFirstNameRow ()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.account_circle,
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
                  controller: firstNameController,
                  decoration: new InputDecoration(
                    labelText: 'First Name',
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
      margin: EdgeInsets.all(25),
    );
  }

  Widget buildLastNameRow ()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.more_horiz,
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
                  controller: lastNameController,
                  decoration: new InputDecoration(
                    labelText: 'Last Name',
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
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildParentNameRow()
  {
    return Container(
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
                  controller: parentNameController,
                  decoration: new InputDecoration(
                    labelText: 'Parent Name',
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
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildContactNumberRow()
  {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.phone,
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
                  controller: contactNumberController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    _phoneFormatter,
                    LengthLimitingTextInputFormatter(14),
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Contact Number',
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
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildTakePicture ()
  {
    return Column(
      children: <Widget>[
        childImagePath != null ? Container(child: Image.memory(File(childImagePath).readAsBytesSync()), margin: EdgeInsets.all(20),) : Container(),
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.camera_alt,
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
                  Container(
                    child: FlatButton(
                      child: Text("Take Picture", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        checkTakePictureResponse();
                      },
                    ),
                    decoration: new BoxDecoration(
                      color: primaryWidgetColor,
                      borderRadius: new BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
        ),
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Container(
                    child: Icon(
                      Icons.add_a_photo,
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
                  Container(
                    child: FlatButton(
                      child: Text("Select Picture", style: TextStyle(color: Colors.white)),
                      onPressed: getImage,
                    ),
                    decoration: new BoxDecoration(
                      color: primaryWidgetColor,
                      borderRadius: new BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  )
                ]
            ),
          ),
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
        ),
      ],
    );
  }

  Widget buildBusRow()
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
                      Icons.directions_bus,
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
                      controller: busController,
                      decoration: new InputDecoration(
                        labelText: "Bus",
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
          margin: EdgeInsets.only(left: 25, right: 25,),
        ),
        FutureBuilder(
            future: widget.futureBuses == null ? storage.readToken().then((value) async {
              widget.futureBuses = RetrieveBuses(value);
              return widget.futureBuses;
            }) : widget.futureBuses,
            builder: (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Issue Posting Data');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text("Bus Ids failed to load");
                  } else {
                    busIndex = widget.driversBus != null ? matchBusIds(snapshot.data, widget.driversBus) : 0;
                    return Container(
                      child: DropdownButton<Bus>(
                        value: snapshot.data[busIndex],
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
                        onChanged: (Bus newValue) {
                          setState(() {
                            busIndex = snapshot.data.indexOf(newValue);
                            busController.text = newValue.id == null ? "" : '${newValue.id}';
                          });
                        },
                        items: snapshot.data
                            .map<DropdownMenuItem<Bus>>((Bus value) {
                          return DropdownMenuItem<Bus>(
                            value: value,
                            child: value.id == null ? Text('Select Bus', style: TextStyle(fontSize: 16, decoration: TextDecoration.none,)) : Text('${value.id}', style: TextStyle(fontSize: 16, decoration: TextDecoration.none,)),
                          );
                        }).toList(),
                      ),
                      margin: EdgeInsets.only(bottom: 25,),
                    );
                  }
                  break;
                default:
                  return null;
              }
            }
        )
      ],
    );
  }

  Widget buildButtonBar ()
  {
    return ButtonBar(
      children: <Widget>[
        OutlineButton(
          child: Text('Additional Options', style: TextStyle(color: Colors.deepPurple),),
          onPressed: ()
          {
            if (additionalFilledOut())
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalOptionsPage(firstName: firstNameController.text,
                lastName: lastNameController.text, parentName: parentNameController.text,
                contactNumber: parseNumber(contactNumberController.text), imagePath: childImagePath,)));
          },
        ),
        RaisedButton(
          child: const Text('Add Child'),
          onPressed: ()
          {
            if (filledOut())
              storage.readToken().then((value) {
                CreateChildBase(value, firstNameController.text, lastNameController.text,
                    parentNameController.text, contactNumberController.text,
                    busController.text, childImagePath, context);
              });
          },
          color: primaryColor,
        ),
      ],
    );
  }

  @override
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text("Add Child"),
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
                  buildFirstNameRow(),
                  buildLastNameRow(),
                  buildParentNameRow(),
                  buildContactNumberRow(),
                  buildBusRow(),
                  buildTakePicture(),
                  buildButtonBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}