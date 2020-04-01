import 'package:flutter/material.dart';
import 'package:operationportal/REST/Get_RetrieveVolunteers.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Storage.dart';
import 'package:operationportal/Structs/Volunteer.dart';
import 'package:operationportal/Widget/VolunteerProfile.dart';



class VolunteerWidgetPage extends StatefulWidget {
  VolunteerWidgetPage({Key key, this.storage}) : super(key: key);

  final Storage storage;

  @override
  VolunteerWidgetState createState() => VolunteerWidgetState();
}
class VolunteerWidgetState extends State<VolunteerWidgetPage>
{
  void filterVolunteerResults(String query) {
    if (volunteers == null || volunteerData == null)
      return;

    query = query.toUpperCase();

    List<Volunteer> dummySearchList = List<Volunteer>();
    dummySearchList.addAll(volunteerData);
    if(query.isNotEmpty) {
      List<Volunteer> dummyListData = List<Volunteer>();
      dummySearchList.forEach((item) {
        if(item.firstName.toUpperCase().contains(query) || item.lastName.toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      displayVolunteers.clear();
      displayVolunteers.addAll(dummyListData);
      setState(() {
      });
    } else {
      displayVolunteers.clear();
      setState(() {
      });
    }
  }

  List<Volunteer> displayVolunteers = new List<Volunteer>();
  List<Volunteer> volunteers = new List<Volunteer>();
  List<Volunteer> volunteerData = new List<Volunteer>();

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
                        filterVolunteerResults(value);
                      },
                      decoration: InputDecoration(
                          labelText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.all(10),
        ),
        FutureBuilder(
            future: widget.storage.readToken().then((value) {
              return RetrieveVolunteers(value, "${DateTime.now().toLocal()}".split(' ')[0]);
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
                    volunteers = displayVolunteers.length > 0 ? displayVolunteers : snapshot.data;
                    return Expanded(
                      child: new ListView.builder(
                        itemCount: volunteers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: ListTile(
                              leading: Container(
                                child: CircleAvatar(
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
                            color: Colors.blue[colorCodes[index%2]],
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