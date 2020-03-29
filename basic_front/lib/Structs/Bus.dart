
//GET api/bus-info
//Roles accessed by: staff
//Input:
//{}
//Output:
//On success {“error”:”string”, “bus”: {"id": int,
//"driverId": int,
//"driverName": "string",
//"name": "string",
//"route": "string",
//"lastOilChange": DateTime,
//"lastTireChange": DateTime,
//"lastMaintenance": DateTime}}
//On failure {“error”:”string”}

class Bus {
  int id;
  String name;
  // Staff only var
  int driverId;
  String driverName;
  String route;
  String lastOilChange;
  String lastTireChange;
  String lastMaintenance;

  Bus({this.id, this.name, this.driverId, this.driverName,
  this.route, this.lastOilChange, this.lastTireChange, this.lastMaintenance});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'] != null ?  json['name'] : "N/A",
      driverId: json['driverId'],
      driverName: json['driverName'] != null ?  json['driverName'] : "N/A",
      route: json['route'] != null ?  json['route'] : "N/A",
      lastOilChange: json['lastOilChange'] != null ?  json['lastOilChange'] : "N/A",
      lastTireChange: json['lastTireChange'] != null ?  json['lastTireChange'] : "N/A",
      lastMaintenance: json['lastMaintenance'] != null ?  json['lastMaintenance'] : "N/A",
    );
  }
}