import 'dart:convert';

import 'package:basic_front/Volunteer/Volunteer_InactiveDashboard.dart';
import 'package:basic_front/ForgotPassword.dart';
import 'package:basic_front/RegisterAccount.dart';
import 'package:flutter/material.dart';
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
        brightness: Brightness.dark
      ),
      home: LoginPage(title: 'Operation Portal Login'),
    );
  }
}


Future<Post> fetchPost() async {
  final response =
  await http.get('');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String email;
  final String firstName;
  final String lastName;
  final List<String> roles;

  Post({this.email, this.firstName, this.lastName, this.roles});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email: json[''],
      firstName: json[''],
      lastName: json[''],
      roles: json[''].cast<String>(),
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
  Future<Post> post;

  @override
  void initState()
  {
    super.initState();
    post = fetchPost();
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

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode usernameNode = new FocusNode();
  FocusNode passwordNode = new FocusNode();
  FocusNode confirmPasswordNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
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
                    margin: EdgeInsets.only(top: 20, left: 20, bottom: 5),
                  ),
                  Container(
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    margin: EdgeInsets.only(top: 20, left: 20, bottom: 15),
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
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
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
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ]
                      ),
                    ),
                    margin: EdgeInsets.only(left: 25, right: 25, bottom: 35),
                  ),
                  Container(
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
                  ),
                ]
              )
            ),
            /// We use [Builder] here to use a [context] that is a descendant of [Scaffold]
            /// or else [Scaffold.of] will return null
            Container (
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: new SizedBox(
                    width: 200,
                    child: RaisedButton(
                      child: const Text('Login', style: TextStyle(fontSize: 24)),
                      onPressed: ()
                      {
                        if (_emailController.text == "st")
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Staff_ActiveDashboard_Page(title: 'Dashboard')));
                        else if (_emailController.text == "bd")
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BusDriver_InactiveDashboard_Page(title: 'Dashboard')));
                        else if (_emailController.text == "vc")
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_InactiveDashboard_Page(title: 'Dashboard')));
                        else
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Volunteer_InactiveDashboard_Page(title: 'Dashboard')));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                )
            )
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
          ],
        ),
      ),
    );
  }
}




