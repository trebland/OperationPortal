import 'package:flutter/material.dart';
import 'package:operationportal/REST/Delete_Note.dart';
import 'package:operationportal/REST/Post_EditNote.dart';
import 'package:operationportal/Structs/Note.dart';

import 'file:///C:/Users/gecco/Documents/GitHub/OperationPortal/operationportal/lib/Structs/Storage.dart';



class NoteViewPage extends StatefulWidget {
  NoteViewPage({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  NoteViewState createState() => NoteViewState();
}

class NoteViewState extends State<NoteViewPage>
{

  TextEditingController _noteController = new TextEditingController();
  TextEditingController _authorController = new TextEditingController();

  bool noteControllerEditable;

  Storage storage;
  String originalNote;

  void switchOnOffEdit ()
  {
    if (!noteControllerEditable)
      {
        setState(() {
          noteControllerEditable = true;
        });
      }
    else
      {
        setState(() {
          noteControllerEditable = false;
        });
      }

  }

  void submitNoteEdit ()
  {
    switchOnOffEdit();
    storage.readToken().then((value) {
      EditNote(value, widget.note.noteId, _noteController.text, context);
    });
  }

  void discardChanges()
  {
    setState(() {
      switchOnOffEdit();
      _noteController.text = originalNote;
    });
  }

  void deleteNote ()
  {
    storage.readToken().then((value) {
      DeleteNote(value, widget.note.noteId, context);
    });
  }

  @override
  void initState() {
    super.initState();

    storage = new Storage();
    originalNote = widget.note.content;
    _noteController.text = originalNote;
    _authorController.text = widget.note.author;

    noteControllerEditable = false;
  }

  Widget buildNoteRow () {
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
                  controller: _noteController,
                  keyboardType: TextInputType.multiline,
                  enabled: noteControllerEditable,
                  maxLines: 3,
                  decoration: new InputDecoration(
                    labelText: 'Notes',
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

  Widget buildAuthorRow () {
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
                  controller: _authorController,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  maxLines: null,
                  decoration: new InputDecoration(
                    labelText: 'Author',
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

  Widget buildEditNoteButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              noteControllerEditable ? "Submit Changes" : "Edit Note",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            noteControllerEditable ? submitNoteEdit() : switchOnOffEdit();
          },
          color: Colors.amber,
        ),
        height: 50,
        width: double.infinity,
      ),
      margin: EdgeInsets.all(25),
    );
  }
  Widget buildDeleteNodeButton (BuildContext context)
  {
    return Container(
      child: SizedBox(
        child: RaisedButton(
          child: Text(
              noteControllerEditable ? "Discard Changes" : "Delete Note",
              style: TextStyle(fontSize: 24, color: Colors.black)
          ),
          onPressed: () {
            noteControllerEditable ? discardChanges() : deleteNote();
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
          title: Text("Note Edit/Deletion"),
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
                            buildNoteRow(),
                            buildAuthorRow(),
                          ],
                        )
                    ),
                    buildEditNoteButton(context),
                    buildDeleteNodeButton(context),
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