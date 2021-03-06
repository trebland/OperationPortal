import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:operationportal/ForgotPassword.dart';
import 'package:operationportal/REST/Post_Login.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/RegisterAccount.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  @override
  void initState()
  {
    super.initState();
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FocusNode usernameNode = new FocusNode();
  FocusNode passwordNode = new FocusNode();

  Widget buildHeader ()
  {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Welcome to",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            child: Image.asset('assets/OCC_LOGO.png'),
            width: 400,
            height: 200,
            margin: EdgeInsets.only(top: 10),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 60, bottom: 50),
    );
  }

  Widget buildEmailRow ()
  {
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
                  color: primaryWidgetColor,
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
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(" ")),
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Email',
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
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildPasswordRow ()
  {
    return Container(
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
                  color: primaryWidgetColor,
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
                  obscureText: true,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(" ")),
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Password',
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
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 35),
    );
  }

  Widget buildForgotOrRegister ()
  {
    return Container(
      child: Column(
        children: <Widget>[
          Builder(
              builder: (context) => Center(
                  child: RaisedButton(
                    child: Text('Forgot Password?',
                      style: TextStyle(color: textComplementColor)),
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    color: primaryWidgetColor,
                  )
              )
          ),
          Text(
              "OR", style: TextStyle(fontWeight: FontWeight.bold)
          ),
          Builder(
              builder: (context) => Center(
                  child: FlatButton(
                    child: Text('New Volunteer',
                        style: TextStyle(color: textComplementColor)),
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterAccountPage()),
                      );
                    },
                    color: primaryWidgetColor,
                  )
              )
          )
        ],
      ),
    );
  }

  Widget buildLoginButton ()
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              "Login",
              style: TextStyle(fontSize: 24, color: Colors.white)
          ),
          onPressed: () {
            Login(_emailController.text, _passwordController.text, context);
            // LoginCheck(_emailController.text);
          },
          color: primaryColor,
        ),
        height: 50,
        width: double.infinity,
      ),
      margin: EdgeInsets.all(25),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          children: <Widget>[
                            buildHeader(),
                            buildEmailRow(),
                            buildPasswordRow(),
                            buildForgotOrRegister(),
                          ],
                        )
                    ),
                    buildLoginButton(),
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




