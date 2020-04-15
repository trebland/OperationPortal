/*
"id": int,
"driverId": int,
"driverName": "string",
“driverPicture”:byte[],
"name": "string",
"route": "string",
"lastOilChange": DateTime,
"lastTireChange": DateTime,
"lastMaintenance": DateTime
*/


class Bus {
  int id;
  String name;
  // Staff only var
  int driverId;
  String driverName;
  String driverPicture;
  String route;
  DateTime lastOilChange;
  DateTime lastTireChange;
  DateTime lastMaintenance;

  Bus({this.id, this.name, this.driverId, this.driverName, this.driverPicture,
  this.route, this.lastOilChange, this.lastTireChange, this.lastMaintenance});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'] != null ?  json['name'] : "N/A",
      driverId: json['driverId'],
      driverPicture: json['driverPicture'],
      driverName: json['driverName'] != null ?  json['driverName'] : "N/A",
      route: json['route'] != null ?  json['route'] : "N/A",
      lastOilChange: json['lastOilChange'] != null ?
      new DateTime(int.parse(json['lastOilChange'].split('-')[0]),
          int.parse(json['lastOilChange'].split('-')[1]),
          int.parse(json['lastOilChange'].split('-')[2].split('T')[0])) : null,
      lastTireChange: json['lastTireChange'] != null ?
      new DateTime(int.parse(json['lastTireChange'].split('-')[0]),
          int.parse(json['lastTireChange'].split('-')[1]),
          int.parse(json['lastTireChange'].split('-')[2].split('T')[0])) : null,
      lastMaintenance: json['lastMaintenance'] != null ?
      new DateTime(int.parse(json['lastMaintenance'].split('-')[0]),
          int.parse(json['lastMaintenance'].split('-')[1]),
          int.parse(json['lastMaintenance'].split('-')[2].split('T')[0])) : null,
    );
  }
}