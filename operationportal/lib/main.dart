import 'package:flutter/material.dart';
import 'package:operationportal/Login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operation Portal',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff1c415b,
          const <int, Color>{
          50:  const Color(0xff0DBAFF),
          100: const Color(0xff0DBAFF),
          200: const Color(0xff0DBAFF),
          300: const Color(0xff0DBAFF),
          400: const Color(0xff0DBAFF),
          500: const Color(0xff1c415b),
          600: const Color(0xff0DBAFF),
          700: const Color(0xff0DBAFF),
          800: const Color(0xff0DBAFF),
          900: const Color(0xff0DBAFF),
        },
        ),
        secondaryHeaderColor: Colors.amberAccent,
        primaryTextTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24.0),
          body1: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(),
    );
  }
}