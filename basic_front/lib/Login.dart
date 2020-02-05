import 'dart:convert';

import 'package:basic_front/Volunteer/Volunteer_ActiveDashboard.dart';
import 'package:basic_front/Volunteer/Volunteer_InactiveDashboard.dart';
import 'package:basic_front/ForgotPassword.dart';
import 'package:basic_front/RegisterAccount.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Bus_Driver/BusDriver_InactiveDashboard.dart';
import 'Staff/Staff_ActiveDashboard.dart';
import 'Volunteer_Captain/VolunteerCaptain_InactiveDashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operation Portal Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
        secondaryHeaderColor: Colors.amberAccent,
        primaryTextTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24.0),
          body1: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(title: 'Operation Portal Login'),
    );
  }
}


class Profile {
  int id;
  String firstName;
  String lastName;
  String role;

  Profile ({this.id, this.firstName, this.lastName, this.role});

  factory Profile.fromJson (Map<String, dynamic> json)
  {
    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
    );
  }
}

class RetrieveUser_Success {
  Profile profile;

  RetrieveUser_Success({this.profile});

  factory RetrieveUser_Success.fromJson(Map<String, dynamic> json) {
    return RetrieveUser_Success(
        profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}

class RetrieveUser_Failure {
  String error;

  RetrieveUser_Failure({this.error});

  factory RetrieveUser_Failure.fromJson(Map<String, dynamic> json) {
    return RetrieveUser_Failure(
      error: json['error'],
    );
  }
}

class InitialLogin_Success {
  final String accessToken;
  final String errorDescription;

  InitialLogin_Success({this.accessToken, this.errorDescription});

  factory InitialLogin_Success.fromJson(Map<String, dynamic> json) {
    return InitialLogin_Success(
      accessToken: json['access_token'],
      errorDescription: json['error_description'],
    );
  }
}

class InitialLogin_Failure {
  final String errorDescription;

  InitialLogin_Failure({this.errorDescription});

  factory InitialLogin_Failure.fromJson(Map<String, dynamic> json) {
    return InitialLogin_Failure(
      errorDescription: json['error_description'],
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  int _counter = 0;



  Future<void> POST_InitialLogin(String username, String passwordText) async {
    var mUrl = "https://www.operation-portal.com/api/auth/token";

    Map<String, String> body = {
      'grant_type': 'password',
      'username': '$username',
      'password': '$passwordText',
    };

    var response = await http.post(mUrl,
        body: body,
        headers: {'Content-type': 'application/x-www-form-urlencoded'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      InitialLogin_Success mPost = InitialLogin_Success.fromJson(json.decode(response.body));

      GET_RetrieveUser(mPost.accessToken);
    } else {
      // If that call was not successful, throw an error.
      InitialLogin_Failure mPost = InitialLogin_Failure.fromJson(json.decode(response.body));

      Fluttertoast.showToast(
          msg: "Email or password is incorrect",
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

  Future<void> GET_RetrieveUser (String token) async {
    var mUrl = "https://www.operation-portal.com/api/auth/user";

    var response = await http.get(mUrl,
        headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      RetrieveUser_Success mPost = RetrieveUser_Success.fromJson(json.decode(response.body));

      Fluttertoast.showToast(
          msg: mPost.profile.role,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_ActiveDashboard_Page(title: 'Dashboard')));
      return mPost;
    } else {
      // If that call was not successful, throw an error.
      RetrieveUser_Failure mPost = RetrieveUser_Failure.fromJson(json.decode(response.body));

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

  @override
  void initState()
  {
    super.initState();
  }

  void _callApi(BuildContext context)
  {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Login Failed'),
        action: SnackBarAction(
            label: 'CLEAR', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void LoginCheck (String toCheck)
  {
    if (toCheck == "st")
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Staff_ActiveDashboard_Page(title: 'Dashboard')));
    else if (toCheck == "bd")
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusDriver_InactiveDashboard_Page(title: 'Dashboard')));
    else if (toCheck == "vc")
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_InactiveDashboard_Page(title: 'Dashboard')));
    else
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_InactiveDashboard_Page(title: 'Dashboard')));
  }

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode usernameNode = new FocusNode();
  FocusNode passwordNode = new FocusNode();
  FocusNode confirmPasswordNode = new FocusNode();

  Widget buildHeader ()
  {
    return Container(
      child: Text(
        "Orlando Children's Church",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(top: 120, bottom: 50),
    );
  }

  Widget buildEmailRow ()
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
                  onSubmitted: (String value) {
                    FocusScope.of(context).requestFocus(passwordNode);
                  },
                  textAlign: TextAlign.left,
                  controller: _emailController,
                  decoration: new InputDecoration(
                    hintText: 'Email',
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
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildPasswordRow ()
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
                  focusNode: passwordNode,
                  controller: _passwordController,
                  decoration: new InputDecoration(
                    hintText: 'Password',
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
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 35),
    );
  }

  Widget buildForgotOrRegister ()
  {
    return Container(
      child: Column(
        children: <Widget>[
          Builder(
              builder: (context) => Center(
                  child: FlatButton(
                    child: const Text('Forgot Password?'),
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                  )
              )
          ),
          Text(
              "OR"
          ),
          Builder(
              builder: (context) => Center(
                  child: FlatButton(
                    child: const Text('Register Account'),
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterAccountPage()),
                      );
                    },
                  )
              )
          )
        ],
      ),
    );
  }

  Widget buildLoginButton ()
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              "Login",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            // POST_InitialLogin(_emailController.text, _passwordController.text);
            LoginCheck(_emailController.text);
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
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          children: <Widget>[
                            buildHeader(),
                            buildEmailRow(),
                            buildPasswordRow(),
                            buildForgotOrRegister(),
                          ],
                        )
                    ),
                    buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

            /*
            child: Builder(
                      builder: (context) => Center(
                        child: new SizedBox(
                          child: RaisedButton(
                            child: const Text('Login', style: TextStyle(fontSize: 24)),
                            onPressed: () => _callApi(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        )
                      ),
                    ),
             */

            /*
            FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.firstName);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ), */
  }
}




