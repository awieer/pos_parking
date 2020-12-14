class PayParkirResponse {
  bool success;
  String status;
  Data data;

  PayParkirResponse(this.success, this.status, this.data);

  PayParkirResponse.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        status = json["status"],
        data = Data.fromJson(json["data"]);
}

class Data {
  int id;
  String createdAt;
  ParkingPassOption parkingPassOption;
  Pbt pbt;
  Plate plate;

  Data(this.id, this.createdAt, this.parkingPassOption, this.pbt, this.plate);

  Data.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        createdAt = json["created_at"],
        parkingPassOption =
            ParkingPassOption.fromJson(json["parking_pass_option"]),
        pbt = Pbt.fromJson(json["pbt"]),
        plate = Plate.fromJson(json["plate"]);
}

class ParkingPassOption {
  String name;
  dynamic price;

  ParkingPassOption(this.name, this.price);

  ParkingPassOption.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        price = json["price"];
}

class Pbt {
  String name;
  String alias;

  Pbt(this.name, this.alias);

  Pbt.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        alias = json["alias"];
}

class Plate {
  String plateNumber;

  Plate(this.plateNumber);

  Plate.fromJson(Map<String, dynamic> json)
      : plateNumber = json["plate_number"];
}

// {
//     "success": true,
//     "status": "payment successful",
//     "data": {
//         "id": 168,
//         "start_date": "2020-07-31 10:10:10",
//         "end_date": "2020-08-31 10:10:09",
//         "lat": null,
//         "lng": null,
//         "period_count": 1,
//         "period_type": "month",
//         "plate_id": 133,
//         "user_id": 835,
//         "price": 55.65,
//         "pbt_id": 1,
//         "created_at": "30 Jul 2020, 01:36AM",
//         "updated_at": "30 Jul 2020, 01:36AM",
//         "parking_pass_option_id": 1,
//         "status": 0,
//         "payment_id": 3730,
//         "parking_pass_option": {
//             "id": 1,
//             "name": "One(1) month",
//             "period_count": 1,
//             "period_type": "month",
//             "price": 55.65,
//             "pbt_id": 1,
//             "alias": "mpk_monthly_pass",
//             "created_at": "14 Nov 2019, 04:12PM",
//             "updated_at": "22 Nov 2019, 03:43PM",
//             "status": 1
//         },
//         "pbt": {
//             "id": 1,
//             "uid": "P1000001",
//             "name": "Majlis Perbandaran Kuantan",
//             "alias": "mpk",
//             "server_id": 1,
//             "district_id": 1,
//             "created_at": "2019-09-08 20:27:07",
//             "updated_at": "2019-10-15 00:19:33",
//             "coordinates": null,
//             "status": 1,
//             "picture": "https://firebasestorage.googleapis.com/v0/b/pahanggo-app.appspot.com/o/images%2Fpbts%2Fmpk.png?alt=media"
//         },
//         "plate": {
//             "id": 133,
//             "uid": "P1000133",
//             "plate_number": "CCY1234",
//             "model": null,
//             "brand": null,
//             "color": null,
//             "user_id": 835,
//             "created_at": "30 Jul 2020, 01:36AM",
//             "updated_at": "30 Jul 2020, 01:36AM",
//             "is_default": 0,
//             "deleted_at": null
//         },
//         "payment": {
//             "id": 3730,
//             "uid": "P1003730",
//             "amount": "55.65",
//             "payer_entity_id": 835,
//             "payer_entity_type": "user",
//             "status": 1,
//             "remarks": null,
//             "payment_type": "pgo@default_payment_method",
//             "currency": "MYR",
//             "created_at": "2020-07-30 01:36:12",
//             "updated_at": "2020-07-30 01:36:20",
//             "transaction_id": "PGO03730",
//             "payment_for": "parking_pass_purchase@55.65@168",
//             "payment_method": "Pahanggo POS",
//             "payment_vendor": "ipay88",
//             "description": "Parking Pass purchase for 1 month(s) : RM55.65",
//             "product_id": 57,
//             "payment_method_id": null,
//             "district_id": 1,
//             "service_reference_1": null,
//             "service_reference_2": null,
//             "is_synced_to_pbt": 0,
//             "resource_type": null,
//             "resource_id": null,
//             "history_title": "Parking Pass",
//             "payer": {
//                 "id": 835,
//                 "uid": null,
//                 "name": "pos enforcer",
//                 "username": null,
//                 "email": "pos.enforcer@pahanggo.com",
//                 "remember_token": null,
//                 "phone": null,
//                 "ic": null,
//                 "gender": null,
//                 "status": 1,
//                 "picture": null,
//                 "created_at": "2020-07-28 11:48:00",
//                 "updated_at": "2020-07-30 01:36:20",
//                 "last_login": "2020-07-30 01:35:25",
//                 "address": null,
//                 "designation": null,
//                 "department": null,
//                 "channel": "email",
//                 "oauth_token": null,
//                 "pgo_token": 0,
//                 "linked_accounts": {
//                     "email": "linked"
//                 },
//                 "is_email_verified": 0,
//                 "is_phone_verified": 0,
//                 "language": "en",
//                 "app_version": null,
//                 "passport": null,
//                 "nationality": null,
//                 "status_description": "Active"
//             },
//             "product": {
//                 "id": 57,
//                 "uid": "P1000066",
//                 "name": "Parking Pass",
//                 "description": null,
//                 "picture": null,
//                 "category_id": null,
//                 "subcategory_id": null,
//                 "price": null,
//                 "denomination": null,
//                 "have_bills": 0,
//                 "is_shown": 0,
//                 "created_at": "2019-11-14 11:51:22",
//                 "updated_at": "2019-11-14 11:51:22",
//                 "fields": null,
//                 "merchant_code": null,
//                 "fpx_pmargin": 0,
//                 "fpx_pmargin_is_percentage": 0,
//                 "cc_margin": 0,
//                 "cc_margin_is_percentage": 0,
//                 "extra_charge_fpx": 0,
//                 "extra_charge_fpx_is_percentage": 0,
//                 "extra_charge_cc": 0,
//                 "extra_charge_cc_is_percentage": 0,
//                 "extra_charge_label": null,
//                 "merchant_id": null,
//                 "is_disabled": 0,
//                 "transaction_max_limit": null,
//                 "merchant": null
//             }
//         }
//     }
// }
