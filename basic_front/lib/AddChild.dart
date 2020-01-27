import 'package:flutter/material.dart';

class AddChildPage extends StatefulWidget {
  AddChildPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  AddChildState createState() => AddChildState();
}

class AddChildState extends State<AddChildPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
          child: Column (
            children: <Widget>[
              Container(
                child: Image(
                    image: AssetImage('assets/OCC_LOGO_128_128.png')
                ),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(20)
                  ),
                ),
                margin: EdgeInsets.only(top: 20, left: 20, bottom: 5),
              ),
              Container(
                child: Text(
                  "Add Child",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                margin: EdgeInsets.only(top: 20, left: 20, bottom: 15),
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
                child: IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [
                        Container(
                          child: Icon(
                            Icons.cake,
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
                              hintText: 'Birthday',
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
                child: IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [
                        Container(
                          child: Icon(
                            Icons.grade,
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
                              hintText: 'Grade',
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
                child: IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [
                        Container(
                          child: Icon(
                            Icons.camera_alt,
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
                        Container(
                          child: FlatButton(
                            child: Text("Take Picture", style: TextStyle(color: Colors.white)),
                            onPressed: () => null,
                          ),
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 5),
                        ),
                      ]
                  ),
                ),
                margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
              ),
              Expanded (
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: new SizedBox(
                      child: RaisedButton(
                        child: const Text('Add Child', style: TextStyle(fontSize: 24)),
                        onPressed: ()
                        {
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}