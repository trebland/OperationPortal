import 'package:basic_front/Login.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Account Registration - Email"),
        ),
        body: new Column (
          children: <Widget>[
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
                child: FlatButton(
                  child: Text("Next"),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new FullNameScreen()));
                  },
                )
            ),
          ],
        )
    );
  }
}

class FullNameScreen extends StatelessWidget {

  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Account Registration - Name"),
        ),
        body: new Column (
          children: <Widget>[
            Container(
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
                          controller: _emailController,
                          decoration: new InputDecoration(
                            hintText: 'Full Name',
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
                child: FlatButton(
                  child: Text("Next"),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new PasswordScreen()));
                  },
                )
            ),
          ],
        )
    );
  }
}

class PasswordScreen extends StatelessWidget {

  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  FocusNode confirmPasswordNode = new FocusNode();

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Account Registration - Password"),
        ),
        body: new Column (
          children: <Widget>[
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
                          focusNode: confirmPasswordNode,
                          controller: _confirmPasswordController,
                          decoration: new InputDecoration(
                            hintText: 'Confirm Password',
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
                child: FlatButton(
                  child: Text("Next"),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new PictureScreen()));
                  },
                )
            ),
          ],
        )
    );
  }
}

class PictureScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Account Registration - Picture"),
        ),
        body: new Column (
          children: <Widget>[
            Container(
                child: FlatButton(
                  child: Text("Submit"),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(title: 'Dashboard')), (Route<dynamic> route) => false);
                  },
                )
            ),
          ],
        )
    );
  }
}