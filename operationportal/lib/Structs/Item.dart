class Item {
  String name;
  int count;
  int id;
  bool resolved;
  String addedBy;

  Item({this.name, this.count, this.id, this.resolved, this.addedBy});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      count: json['count'],
      id: json['id'] != null ? json['id'] : null,
      resolved: json['resolved'] != null ? json['resolved'] : false,
      addedBy: json['addedBy'] != null ? json['addedBy'] : null,
    );
  }
}