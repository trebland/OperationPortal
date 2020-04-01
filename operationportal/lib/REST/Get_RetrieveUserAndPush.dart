import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:operationportal/Structs/User.dart';
import 'package:operationportal/Widget/InactiveDashboard.dart';

import 'file:///C:/Users/gecco/Documents/GitHub/OperationPortal/operationportal/lib/Dashboards/BusDriver_ActiveDashboard.dart';
import 'file:///C:/Users/gecco/Documents/GitHub/OperationPortal/operationportal/lib/Dashboards/Staff_ActiveDashboard.dart';
import 'file:///C:/Users/gecco/Documents/GitHub/OperationPortal/operationportal/lib/Dashboards/VolunteerCaptain_ActiveDashboard.dart';
import 'file:///C:/Users/gecco/Documents/GitHub/OperationPortal/operationportal/lib/Dashboards/Volunteer_ActiveDashboard.dart';

Future<User> RetrieveUserAndPush (String token, BuildContext context) async {
  var mUrl = "https://www.operation-portal.com/api/auth/user";

  var response = await http.get(mUrl,
      headers: {'Content-type': 'application/x-www-form-urlencoded', 'Authorization': 'Bearer ' + token});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    User mPost = User.fromJson(json.decode(response.body));

    if (mPost.profile.role == "Staff")
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Staff_ActiveDashboard_Page(user: mPost,)));
    else if (mPost.checkedIn)
    {
      if (mPost.profile.role == "BusDriver")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusDriver_ActiveDashboard_Page(user: mPost,)));
      else if (mPost.profile.role == "VolunteerCaptain")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerCaptain_ActiveDashboard_Page(user: mPost,)));
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteer_ActiveDashboard_Page(user: mPost,)));
    }
    else
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InactiveDashboardPage(profile: mPost.profile, accessToken: token,)));
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