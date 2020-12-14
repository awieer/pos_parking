class ParkingPassMonthly {
  bool success;
  List<Pass> data;

  ParkingPassMonthly(this.success, this.data);

  ParkingPassMonthly.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        data = json["data"] != null
            ? (json["data"] as List).map((i) => Pass.fromJson(i)).toList()
            : null;
}

class Pass {
  int id;
  String name;
  dynamic price;
  int pbtId;

  Pass(this.id, this.name, this.price, this.pbtId);

  Pass.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        price = json["price"],
        pbtId = json["pbt_id"];
}
