class AddVehicleResponse {
  bool success;
  String message;
  AddVehicledata data;

  AddVehicleResponse(this.success, this.message, this.data);
  AddVehicleResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        message = json["message"],
        data = AddVehicledata.fromJson(json["data"]);
}

class AddVehicledata {
  String plateNumber;
  int userId;
  String updatedAt;
  String createdAt;
  int id;
  String uid;
  bool isDefault;

  AddVehicledata(this.plateNumber, this.userId, this.updatedAt, this.createdAt,
      this.id, this.uid, this.isDefault);

  AddVehicledata.fromJson(Map<String, dynamic> json)
      : plateNumber = json["plate_number"],
        userId = json["user_id"],
        updatedAt = json["updated_at"],
        createdAt = json["created_at"],
        id = json["id"],
        uid = json["uid"],
        isDefault = json["is_default"];
}

class AddVehicleFailedResponse {
  bool success;
  String message;

  AddVehicleFailedResponse(this.success, this.message);
  AddVehicleFailedResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        message = json["message"];
}
