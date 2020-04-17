import 'package:flutter/material.dart';
import 'package:operationportal/REST/Get_RetrieveVolunteerTrainings.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Training.dart';

class TrainingViewerPage extends StatefulWidget {
  TrainingViewerPage({Key key, this.previouslySelectedIds}) : super(key: key);

  final List<int> previouslySelectedIds;

  @override
  TrainingViewerState createState() => TrainingViewerState();
}

class TrainingViewerState extends State<TrainingViewerPage> {

  Storage storage;
  List<bool> trainingsSelected;
  List<int> trainingIds;
  List<Training> trainings;

  @override
  void initState() {
    storage = new Storage();
    trainingIds = widget.previouslySelectedIds;

    super.initState();
  }

  List<bool> returnListSizeOfN (List<Training> listOf)
  {
    List<bool> tempList = new List<bool>();
    for (Training t in listOf)
      {
        trainingIds.contains(t.id) ? tempList.add(true) : tempList.add(false);
      }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          trainings != null ?
          Expanded(
            child: new ListView.builder(
              itemCount: trainings.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: CheckboxListTile(
                    value: trainingsSelected[index],
                    onChanged: (bool value) {
                      setState(() {
                        trainingsSelected[index] = !trainingsSelected[index];
                        trainingIds.contains(trainings[index].id)
                            ? trainingIds.remove(trainings[index].id)
                            : trainingIds.add(trainings[index].id);
                      });
                    },
                    title: Text('${trainings[index].name}',
                        style: TextStyle(color: Colors.white)),
                    dense: false,
                  ),
                  color: index%2 == 0 ? primaryWidgetColor : secondaryWidgetColor,
                );
              },
            ),
          )
          : FutureBuilder(
              future: storage.readToken().then((value) {
                return GetTrainings(value);
              }),
              builder: (BuildContext context, AsyncSnapshot<List<Training>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text('Issue Posting Data');
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  case ConnectionState.active:
                    return new Text('');
                  case ConnectionState.done:
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(
                        child: Text("No Suspended Students/Issues Connecting"),
                      );
                    } else {
                      trainings = snapshot.data;
                      trainingsSelected = trainingsSelected == null ? returnListSizeOfN(snapshot.data) : trainingsSelected;
                      return Expanded(
                        child: new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: CheckboxListTile(
                                value: trainingsSelected[index],
                                onChanged: (bool value) {
                                  setState(() {
                                    trainingsSelected[index] = !trainingsSelected[index];
                                    trainingIds.contains(snapshot.data[index].id)
                                        ? trainingIds.remove(snapshot.data[index].id)
                                        : trainingIds.add(snapshot.data[index].id);
                                  });
                                },
                                title: Text('${snapshot.data[index].name}',
                                    style: TextStyle(color: Colors.white)),
                                dense: false,
                              ),
                              color: index%2 == 0 ? primaryWidgetColor : secondaryWidgetColor,
                            );
                          },
                        ),
                      );
                    }
                    break;
                  default:
                    return null;
                }
              }
          ),
          RaisedButton(
            child: Text("Confirm Training Selections"),
            onPressed: ()
            {
              Navigator.pop(context, trainingIds);
            },
          )
        ],
      ),
    );
  }
}