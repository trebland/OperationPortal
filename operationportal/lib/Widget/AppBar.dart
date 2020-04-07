import 'package:flutter/material.dart';
import 'package:operationportal/Login.dart';
import 'package:operationportal/Structs/Profile.dart';
import 'package:operationportal/Widget/UserProfile.dart';



Widget buildProfileButton (BuildContext context, Profile toPass)
{
  return IconButton(
    icon: Icon(
      Icons.account_circle,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(profile: toPass)));
    },
  );
}

Widget buildLogoutButton (BuildContext context)
{
  return IconButton(
    icon: Icon(
    Icons.exit_to_app,
    color: Colors.white,
    ),
    onPressed: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
  );
}