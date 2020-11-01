import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_parking/config/constants.dart';
import 'package:pos_parking/model/kompaun_pelbagai_response_model.dart';
import 'package:pos_parking/model/kompaun_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KompaunRepository {
  Future<KompaunResponse> findKompaunList(noPlate, token) async {
    String selectedMajlis = "MPK";
    String majlis;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedMajlis = prefs.getString("majlis");
    if (selectedMajlis == "MDCH") {
      majlis = "mdch2";
    } else if (selectedMajlis == "MPK") {
      majlis = "mpk";
    } else if (selectedMajlis == "MPB") {
      majlis = "mpb";
    }
    print(token);
    print(majlis);
    final result = await http.get(
        "$apiUrl/api/feeders/$majlis/compound/vehicle?registration_number=" +
            noPlate,
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

  KompaunResponse parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    return KompaunResponse.fromJson(jsonDecoded);
  }

  Future<KompaunPelbagaiResponse> findKompaunPelbagaiList(data, token) async {
    String selectedMajlis = "MPK";
    String majlis;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedMajlis = prefs.getString("majlis");
    if (selectedMajlis == "MDCH") {
      majlis = "mdch2";
    } else if (selectedMajlis == "MPK") {
      majlis = "mpk";
    } else if (selectedMajlis == "MPB") {
      majlis = "mpb";
    }
    print(token);
    final result = await http.get(
        "$apiUrl/api/feeders/$majlis/compound/other?query=" +
            data +
            "&query_type=3",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        });

    if (result.statusCode != 200) {
      throw Exception();
    } else {
      print("${result.body}");
    }
    return parsedJsonPelbagai(result.body);
  }

  KompaunPelbagaiResponse parsedJsonPelbagai(final response) {
    final jsonDecoded = json.decode(response);
    return KompaunPelbagaiResponse.fromJson(jsonDecoded);
  }
}
