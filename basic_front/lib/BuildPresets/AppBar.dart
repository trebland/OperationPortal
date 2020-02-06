import 'package:flutter/material.dart';

import '../Login.dart';
import '../UserProfile.dart';

Widget buildProfileButton (BuildContext context)
{
  return IconButton(
    icon: Icon(
      Icons.account_circle,
      color: Colors.black,
    ),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(title: 'Profile')));
    },
  );
}

Widget buildLogoutButton (BuildContext context)
{
  return IconButton(
    icon: Icon(
    Icons.exit_to_app,
    color: Colors.black,
    ),
    onPressed: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
  );
}