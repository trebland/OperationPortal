import 'package:flutter/material.dart';
import 'package:operationportal/ItemAddition/AddItem.dart';
import 'package:operationportal/ItemAddition/ItemView.dart';
import 'package:operationportal/REST/Get_RetrieveInventory.dart';
import 'package:operationportal/References/ReferenceConstants.dart';
import 'package:operationportal/Structs/Item.dart';
import 'package:operationportal/Structs/Storage.dart';


class InventoryWidgetPage extends StatefulWidget
{
  InventoryWidgetPage({Key key, this.storage}) : super(key: key);

  Storage storage;

  @override
  InventoryWidgetState createState() => InventoryWidgetState();
}

class InventoryWidgetState extends State<InventoryWidgetPage>
{
  List<Item> displayItems = new List<Item>();
  List<Item> items = new List<Item>();
  List<Item> itemData = new List<Item>();

  void filterInventoryResults(String query) {
    if (items == null || itemData == null)
      return;

    query = query.toUpperCase();

    List<Item> dummySearchList = List<Item>();
    dummySearchList.addAll(itemData);
    if(query.isNotEmpty) {
      List<Item> dummyListData = List<Item>();
      dummySearchList.forEach((item) {
        if(item.name.toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      displayItems.clear();
      displayItems.addAll(dummyListData);
      setState(() {
      });
    } else {
      displayItems.clear();
      setState(() {
      });
    }
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
                        filterInventoryResults(value);
                      },
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          labelText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                      child: FlatButton(
                          child: Text("Add Item"),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemPage()))
                      )
                  ),
                ]
            ),
          ),
          margin: EdgeInsets.all(10),
        ),
        FutureBuilder(
            future: widget.storage.readToken().then((value) {
              return RetrieveInventory(value);
            }),
            builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Issue Posting Data');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    items = null;
                    return Center(
                      child: Text("Unable to Fetch Inventory"),
                    );
                  } else {
                    itemData = snapshot.data;
                    items = displayItems.length > 0 ? displayItems : snapshot.data;
                    return Expanded(
                      child: new ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: ListTile(
                              title: Text('${items[index].name}',
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text('Count: ' + '${items[index].count}',
                                  style: TextStyle(color: Colors.white)),
                              onTap: ()
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ItemViewPage(item: items[index],)));
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