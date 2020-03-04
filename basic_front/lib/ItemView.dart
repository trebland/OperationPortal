import 'package:basic_front/REST/Delete_Note.dart';
import 'package:basic_front/REST/Post_EditInventory.dart';
import 'package:basic_front/REST/Post_EditNote.dart';
import 'package:flutter/material.dart';

import 'BuildPresets/InactiveDashboard.dart';
import 'REST/Post_CreateNote.dart';
import 'Storage.dart';
import 'Structs/Child.dart';
import 'Structs/Item.dart';
import 'Structs/Note.dart';
import 'Structs/Profile.dart';


class ItemViewPage extends StatefulWidget {
  ItemViewPage({Key key, this.item}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Item item;

  @override
  ItemViewState createState() => ItemViewState();
}

enum Resolved { Yes, No}

class ItemViewState extends State<ItemViewPage>
{

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _countController = new TextEditingController();
  TextEditingController _resolvedController = new TextEditingController();
  Resolved _resolved;

  bool itemControllerEditable;


  Storage storage;
  Item originalItem;

  void switchOnOffEdit ()
  {
    if (!itemControllerEditable)
    {
      setState(() {
        itemControllerEditable = true;
      });
    }
    else
    {
      setState(() {
        itemControllerEditable = false;
      });
    }

  }

  void submitNoteEdit ()
  {
    switchOnOffEdit();
    storage.readToken().then((value) {
      EditInventory(value, _nameController.text, int.parse(_countController.text), widget.item.id, _resolvedController.text == "Yes" ? true : false, context);
    });
  }

  void discardChanges()
  {
    setState(() {
      switchOnOffEdit();
      _nameController.text = originalItem.name;
      _countController.text = '${originalItem.count}';
      _resolvedController.text = "";
      _resolved = null;
    });
  }

  void deleteNote ()
  {
    storage.readToken().then((value) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();

    storage = new Storage();
    originalItem = widget.item;
    _nameController.text = originalItem.name;
    _countController.text = '${originalItem.count}';

    itemControllerEditable = false;
  }

  Widget buildNameRow () {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.note,
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
                  controller: _nameController,
                  enabled: itemControllerEditable,
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

  Widget buildCountRow () {
    return Container(
      child: IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Container(
                child: Icon(
                  Icons.flag,
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
                  enabled: itemControllerEditable,
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
        ),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
    );
  }

  Widget buildResolvedColumn ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                      Icons.check,
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
                      controller: _resolvedController,
                      decoration: new InputDecoration(
                        labelText: "Resolved",
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
                      enabled: itemControllerEditable,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.only(top: 25, left: 25, right: 25),
        ),
        ListTile(
          title: const Text('Yes'),
          leading: Radio(
            value: Resolved.Yes,
            groupValue: _resolved,
            onChanged: (Resolved value) {
              setState(() {
                _resolvedController.text = 'Yes';
                _resolved = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio(
            value: Resolved.No,
            groupValue: _resolved,
            onChanged: (Resolved value) {
              setState(() {
                _resolvedController.text = 'No';
                _resolved = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildEditItemButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              itemControllerEditable ? "Submit Changes" : "Edit Item",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            itemControllerEditable ? submitNoteEdit() : switchOnOffEdit();
          },
          color: Colors.amber,
        ),
        height: 50,
        width: double.infinity,
      ),
      margin: EdgeInsets.all(25),
    );
  }

  Widget buildDiscardItemButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              "Discard Changes",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            discardChanges();
          },
          color: Colors.red,
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
        AppBar appBar = AppBar(
          title: Text("Item Edit/Deletion"),
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
                            buildNameRow(),
                            buildCountRow(),
                            buildResolvedColumn(),
                          ],
                        )
                    ),
                    buildEditItemButton(context),
                    itemControllerEditable ? buildDiscardItemButton(context) : Container(),
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