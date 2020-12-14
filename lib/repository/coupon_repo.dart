import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_parking/config/constants.dart';
import 'package:pos_parking/model/coupon_pass_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponPassRepository {
  Future<CouponModel> getParkingPass(token) async {
    String selectedMajlis = "MPK";
    String majlis;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedMajlis = prefs.getString("majlis");
    if (selectedMajlis == "MDCH") {
      majlis = "mdch";
    } else if (selectedMajlis == "MPK") {
      majlis = "mpk";
    } else if (selectedMajlis == "MPB") {
      majlis = "mpb";
    }

    final result = await http.get("$apiUrl/api/pos/" + majlis + "/coupons",
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

  CouponModel parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    return CouponModel.fromJson(jsonDecoded);
  }
}
