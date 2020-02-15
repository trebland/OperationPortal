class Bus {
  int id;
  String name;

  Bus({this.id, this.name});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'],
    );
  }
}