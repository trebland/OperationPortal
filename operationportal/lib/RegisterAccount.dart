import 'dart:convert';
import 'dart:io';

import 'package:operationportal/Login.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'REST/Post_RegisterAccount.dart';

class RegisterAccountPage extends StatefulWidget {
  RegisterAccountPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  RegisterAccountState createState() => RegisterAccountState();
}

class RegisterAccountState extends State<RegisterAccountPage> {

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  Widget buildEmailRow () {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.email,
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
                  controller: _emailController,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(" ")),
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Email',
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.all(25),
    );
  }

  Widget buildFirstNameRow () {
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
                  controller: _firstNameController,
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildLastNameRow () {
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
                  controller: _lastNameController,
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildPasswordRow () {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.lock,
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
                  controller: _passwordController,
                  obscureText: true,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(" ")),
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Password',
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildConfirmPasswordRow () {
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
                  controller: _confirmPasswordController,
                  obscureText: true,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(" ")),
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Confirm Password',
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildPictureButton () {
    return Container(
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
                  color: Colors.blue,
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
                  onPressed: () => null,
                ),
                decoration: new BoxDecoration(
                  color: Colors.blue,
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
    );
  }

  Widget buildRegisterButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              "Register",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            if (_passwordController.text == _confirmPasswordController.text)
              RegisterAccount(context, _emailController.text, _passwordController.text, _firstNameController.text, _lastNameController.text);
            else
              Fluttertoast.showToast(
                  msg: "Passwords don't match",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
          },
          color: Colors.amber,
        ),
        height: 50,
        width: double.infinity,
      ),
      margin: EdgeInsets.all(25),
    );
  }

  @override
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        AppBar appBar = AppBar(
          title: Text("Register Account"),
        );
        return Scaffold (
          appBar: appBar,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - appBar.preferredSize.height*2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildEmailRow(),
                          buildFirstNameRow(),
                          buildLastNameRow(),
                          buildPasswordRow(),
                          buildConfirmPasswordRow(),
                          buildPictureButton(),
                        ],
                      )
                    ),
                    buildRegisterButton(context)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}