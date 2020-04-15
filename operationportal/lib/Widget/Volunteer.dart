import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:operationportal/REST/Get_RetrieveVolunteers.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Language.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Training.dart';
import 'package:operationportal/Structs/Volunteer.dart';
import 'package:operationportal/Widget/TrainingViewer.dart';
import 'package:operationportal/Widget/VolunteerProfile.dart';



class VolunteerWidgetPage extends StatefulWidget {
  VolunteerWidgetPage({Key key, this.storage}) : super(key: key);

  final Storage storage;

  @override
  VolunteerWidgetState createState() => VolunteerWidgetState();
}
class VolunteerWidgetState extends State<VolunteerWidgetPage>
{

  List<int> selectedTrainingIds;

  Future<void> checkTrainingResponse () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrainingViewerPage(previouslySelectedIds: selectedTrainingIds,)),
    );

    updateTrainingSelection (result);
  }

  updateTrainingSelection (List<int> ids)
  {
    setState(() {
      if (ids.isNotEmpty)
        selectedTrainingIds = ids;
      print(ids);
    });
  }

  bool containsLanguage (List<String> languages, String language)
  {
    if (languages == null || languages.isEmpty)
      return false;

    for (String l in languages)
      if (l.toUpperCase().contains(language.toUpperCase()))
        return true;
    return false;
  }

  bool containsTraining (List<Training> trainings, String training)
  {
    if (trainings == null || trainings.isEmpty)
      return false;

    for (Training t in trainings)
      if (t.name.toUpperCase().contains(training.toUpperCase()))
        return true;
    return false;
  }

  bool matchSelectedTrainings (List<Training> trainings, List<int> selectedIds)
  {
    if (selectedIds == null || selectedIds.isEmpty)
      return true;

    if (trainings == null || trainings.isEmpty)
      return false;

    List<bool> satisfiedAll = new List<bool>();

    for (int i in selectedIds)
      for (Training t in trainings)
        if(i == t.id)
          satisfiedAll.add(true);

    if (satisfiedAll.length == selectedIds.length)
      return true;
    else
      return false;

  }

  void filterVolunteerResults(String query) {
    if (volunteers == null || volunteerData == null)
      return;

    query = query.toUpperCase();

    List<Volunteer> dummySearchList = List<Volunteer>();
    dummySearchList.addAll(volunteerData);
    if(query.isNotEmpty) {
      List<Volunteer> dummyListData = List<Volunteer>();
      dummySearchList.forEach((item) {
        if(
        (item.firstName.toUpperCase().contains(query)
            || item.lastName.toUpperCase().contains(query)
            || containsLanguage(item.languages, query)
            || containsTraining(item.trainings, query))
            && matchSelectedTrainings(item.trainings, selectedTrainingIds)) {
          dummyListData.add(item);
        }
      });
      displayVolunteers.clear();
      displayVolunteers.addAll(dummyListData);
    } else if(query.isEmpty && selectedTrainingIds.isNotEmpty) {
      List<Volunteer> dummyListData = List<Volunteer>();
      dummySearchList.forEach((item) {
        if(
        (item.firstName.toUpperCase().contains(query)
            || item.lastName.toUpperCase().contains(query)
            || containsLanguage(item.languages, query)
            || containsTraining(item.trainings, query))
            && matchSelectedTrainings(item.trainings, selectedTrainingIds)) {
          dummyListData.add(item);
        }
      });
      displayVolunteers.clear();
      displayVolunteers.addAll(dummyListData);
    }
    else {
      displayVolunteers.clear();
    }
  }

  List<Volunteer> displayVolunteers = new List<Volunteer>();
  List<Volunteer> volunteers = new List<Volunteer>();
  List<Volunteer> volunteerData = new List<Volunteer>();

  final TextEditingController searchController = new TextEditingController();

  bool filterCheckedIn;

  @override
  void initState() {
    filterCheckedIn = false;
    selectedTrainingIds = new List<int>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>
                [
                  Flexible(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          filterVolunteerResults(value);
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Text("Trainings", style: TextStyle(color: textComplementColor)),
                      onPressed: () {
                        checkTrainingResponse();
                      },
                    ),
                    decoration: new BoxDecoration(
                      color: primaryWidgetColor,
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(20)
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.all(10),
        ),
        Container(
          child: CheckboxListTile(
            title: const Text('Filter Checked In'),
            value: filterCheckedIn,
            onChanged: (bool value) {
              setState(() {
                filterCheckedIn = !filterCheckedIn;
              });
            },
            secondary: const Icon(Icons.filter_tilt_shift),
          ),
        ),
        FutureBuilder(
            future: widget.storage.readToken().then((value) {
              return RetrieveVolunteers(value, "${DateTime.now().toLocal()}".split(' ')[0], filterCheckedIn);
            }),
            builder: (BuildContext context, AsyncSnapshot<List<Volunteer>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Issue Posting Data');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    volunteers = null;
                    return Center(
                      child: Text("Unable to Fetch Volunteers"),
                    );
                  } else {
                    volunteerData = snapshot.data;
                    (searchController.text.isNotEmpty || selectedTrainingIds.isNotEmpty) ? filterVolunteerResults(searchController.text) : null;
                    volunteers = (searchController.text.isNotEmpty || selectedTrainingIds.isNotEmpty) ? displayVolunteers : volunteerData;
                    return Expanded(
                      child: new ListView.builder(
                        itemCount: volunteers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: ListTile(
                              leading: Container(
                                child: CircleAvatar(
                                  backgroundImage: (volunteers[index].picture != null && volunteers[index].picture.isNotEmpty) ? MemoryImage(base64.decode((volunteers[index].picture))) : null,
                                ),
                              ),
                              title: Text('${volunteers[index].firstName} ' + '${volunteers[index].lastName}',
                                  style: TextStyle(color: Colors.white)),
                              onTap: ()
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerProfilePage(volunteer: volunteers[index],)));
                              },
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
      ],
    );
  }

}