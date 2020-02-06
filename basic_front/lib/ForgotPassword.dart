import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordPage>
{

  Widget buildEmailRow () {
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
                  textAlign: TextAlign.left,
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.all(25),
    );
  }

  Widget buildResetButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              "Reset Password",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            Navigator.pop(context);
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        AppBar appBar = AppBar(
          title: Text("Forgot Password"),
        );
        return Scaffold (
          appBar: appBar,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - appBar.preferredSize.height*2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildEmailRow(),
                          ],
                        )
                    ),
                    buildResetButton(context)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}