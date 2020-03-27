import 'package:basic_front/REST/Post_CreateInventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'BuildPresets/InactiveDashboard.dart';
import 'REST/Post_CreateNote.dart';
import 'Storage.dart';
import 'Structs/RosterChild.dart';
import 'Structs/Profile.dart';

class ItemAdditionPage extends StatefulWidget {
  ItemAdditionPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  ItemAdditionState createState() => ItemAdditionState();
}

class ItemAdditionState extends State<ItemAdditionPage>
{

  TextEditingController _itemNameController = new TextEditingController();
  TextEditingController _countController = new TextEditingController();


  Storage storage;
  String countValue;

  @override
  void initState() {
    super.initState();

    storage = new Storage();
    countValue = "Low";
  }

  Widget buildItemNameRow () {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.assignment,
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
                  controller: _itemNameController,
                  decoration: new InputDecoration(
                    labelText: 'Item Name',
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
  Widget buildCountRow()
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
                  Icons.phone,
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
                  controller: _countController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: new InputDecoration(
                    labelText: 'Count',
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
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildAddItemButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              "Add Item",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            storage.readToken().then((value) {
              CreateInventory(value, _itemNameController.text, int.parse(_countController.text), context);
            });
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
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text('Add Item'),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildItemNameRow(),
                  buildCountRow(),
                  buildAddItemButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}