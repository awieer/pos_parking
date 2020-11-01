class ListVehicleResponse {
  bool success;
  String message;
  ListVehicleData response;

  ListVehicleResponse(this.success, this.message, this.response);
  ListVehicleResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        message = json["message"],
        response = ListVehicleData.fromJson(json["response"]);
}

class ListVehicleData {
  List<Plates> plates;

  ListVehicleData(this.plates);

  ListVehicleData.fromJson(Map<String, dynamic> json)
      : plates =
            (json["plates"] as List).map((i) => Plates.fromJson(i)).toList();
}

class Plates {
  int id;
  String plateNumber;

  Plates(this.id, this.plateNumber);

  Plates.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        plateNumber = json["plate_number"];
}
