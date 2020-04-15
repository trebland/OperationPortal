import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Dashboards/BusDriver_ActiveDashboard.dart';
import 'package:operationportal/Dashboards/Staff_ActiveDashboard.dart';
import 'package:operationportal/Dashboards/VolunteerCaptain_ActiveDashboard.dart';
import 'package:operationportal/Dashboards/Volunteer_ActiveDashboard.dart';
import 'package:operationportal/REST/Get_RetrieveUserAndPush.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/InactiveDashboard.dart';
import 'package:operationportal/Widget/LoadingScreen.dart';


Future<void> Login(String username, String passwordText, BuildContext context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreenPage(title: "Logging in",)));
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
    Login_Response loginPost = Login_Response.fromJson(json.decode(response.body));
    Storage storage = new Storage();

    storage.writeToken(loginPost.accessToken);
    // We will retrieve user info here and push our next scene
    var secondaryUrl = "https://www.operation-portal.com/api/auth/user";

    var secondaryResponse = await http.get(secondaryUrl,
        headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + loginPost.accessToken});

    if (secondaryResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      User userPost = User.fromJson(json.decode(secondaryResponse.body));

      if (userPost.profile.role == "Staff")
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Staff_ActiveDashboard_Page(user: userPost,)), (route) => false);
      else if (userPost.checkedIn)
      {
        if (userPost.profile.role == "BusDriver")
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BusDriver_ActiveDashboard_Page(user: userPost,)), (route) => false);
        else if (userPost.profile.role == "VolunteerCaptain")
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ActiveDashboard_Page(user: userPost,)), (route) => false);
        else
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Volunteer_ActiveDashboard_Page(user: userPost,)), (route) => false);
      }
      else
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => InactiveDashboardPage(profile: userPost.profile, accessToken: loginPost.accessToken,)), (route) => false);
      }

      return;
    } else {
      Fluttertoast.showToast(
          msg: "Error retrieving the user profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pop(context);
      throw Exception('Failed to load post');
    }
  } else {
    // If that call was not successful, throw an error.

    Fluttertoast.showToast(
        msg: "Email or password is incorrect",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.pop(context);
    throw Exception('Failed to load post');
  }
}

class Login_Response {
  final String accessToken;
  final String errorDescription;

  Login_Response({this.accessToken, this.errorDescription});

  factory Login_Response.fromJson(Map<String, dynamic> json) {
    return Login_Response(
      accessToken: json['access_token'],
      errorDescription: json['error_description'],
    );
  }
}