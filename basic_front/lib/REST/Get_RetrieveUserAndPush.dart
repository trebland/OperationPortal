import 'dart:convert';

import 'package:basic_front/Bus_Driver/BusDriver_ActiveDashboard.dart';
import 'package:basic_front/Bus_Driver/BusDriver_InactiveDashboard.dart';
import 'package:basic_front/Staff/Staff_ActiveDashboard.dart';
import 'package:basic_front/Structs/Volunteer.dart';
import 'package:basic_front/Volunteer/Volunteer_ActiveDashboard.dart';
import 'package:basic_front/Volunteer/Volunteer_InactiveDashboard.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_ActiveDashboard.dart';
import 'package:basic_front/Volunteer_Captain/VolunteerCaptain_InactiveDashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

Future<Volunteer> RetrieveUserAndPush (String token, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/auth/user";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Volunteer mPost = Volunteer.fromJson(json.decode(response.body));

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Staff_ActiveDashboard_Page(profile: mPost.profile,)));
    else if (mPost.checkedIn)
    {
      if (mPost.profile.role == "Bus Driver")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusDriver_ActiveDashboard_Page(profile: mPost.profile,)));
      else if (mPost.profile.role == "Volunteer Captain")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ActiveDashboard_Page(profile: mPost.profile,)));
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_ActiveDashboard_Page(profile: mPost.profile,)));
    }
    else
    {
      if (mPost.profile.role == "Bus Driver")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusDriver_InactiveDashboard_Page(profile: mPost.profile, accessToken: token,)));
      else if (mPost.profile.role == "Volunteer Captain")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_InactiveDashboard_Page(profile: mPost.profile, accessToken: token,)));
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_InactiveDashboard_Page(profile: mPost.profile, accessToken: token,)));
    }


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

class RetrieveUser_Failure {
  String error;

  RetrieveUser_Failure({this.error});

  factory RetrieveUser_Failure.fromJson(Map<String, dynamic> json) {
    return RetrieveUser_Failure(
      error: json['error'],
    );
  }
}