import 'dart:convert';

import 'package:basic_front/Staff/Staff_ActiveDashboard.dart';
import 'package:basic_front/Structs/Profile.dart';
import 'package:basic_front/Volunteer/Volunteer_ActiveDashboard.dart';
import 'package:basic_front/Volunteer/Volunteer_InactiveDashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Storage.dart';
import 'LoginResponses.dart';

import 'package:http/http.dart' as http;


// Post
Future<void> POST_InitialLogin(String username, String passwordText, BuildContext context) async {
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
    Storage storage = new Storage();

    storage.writeToken(mPost.accessToken);
    RetrieveUserAndPush(mPost.accessToken, context);
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

// Get
Future<Profile> RetrieveUserAndPush (String token, BuildContext context) async {
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

    if (mPost.profile.role == "Staff")
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Staff_ActiveDashboard_Page(title: 'Dashboard')));
    else
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_InactiveDashboard_Page(profile: mPost.profile,)));


    return mPost.profile;
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

// Get
Future<Profile> RetrieveUser (String token, BuildContext context) async {
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

    return mPost.profile;
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