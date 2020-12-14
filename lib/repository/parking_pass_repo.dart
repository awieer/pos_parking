import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_parking/config/constants.dart';
import 'package:pos_parking/model/parking_pass_monthly_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingPassRepository {
  Future<ParkingPassMonthly> getParkingPass(token) async {
    String selectedMajlis = "MPK";
    String majlis;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedMajlis = prefs.getString("majlis");
    if (selectedMajlis == "MDCH") {
      majlis = "9";
    } else if (selectedMajlis == "MPK") {
      majlis = "1";
    } else if (selectedMajlis == "MPB") {
      majlis = "2";
    }

    final result = await http.get("$apiUrl/api/parking_pass_options/" + majlis,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        });

    if (result.statusCode != 200) {
      throw Exception();
    } else {
      print("${result.body}");
    }
    return parsedJson(result.body);
  }

  ParkingPassMonthly parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    return ParkingPassMonthly.fromJson(jsonDecoded);
  }
}
