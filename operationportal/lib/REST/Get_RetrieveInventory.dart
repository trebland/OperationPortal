import 'dart:convert';

import 'package:operationportal/Structs/Item.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> RetrieveInventory (String token) async {


  var mUrl = "https://www.operation-portal.com/api/inventory";

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ' + token,
  };

  var response = await http.get(mUrl,
      headers: headers);

  if (response.statusCode == 200) {
    ReadItems mPost = ReadItems.fromJson(json.decode(response.body));

    return mPost.items;

  } else {

    return null;
  }
}

class ReadItems {

  List<Item> items;

  ReadItems({this.items});

  factory ReadItems.fromJson(Map<String, dynamic> json) {
    return ReadItems(
      items: (json['items'] != null) ? (json['items'].map<Item>((value) => new Item.fromJson(value)).toList()) : (List<Item>()),
    );
  }
}