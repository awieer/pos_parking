import 'package:dio/dio.dart' as http_dio;
import 'package:intl/intl.dart';
import 'package:pos_parking/config/constants.dart';
import 'package:pos_parking/model/add_vehicle_response_model.dart';
import 'package:pos_parking/model/create_parkir_pass_response_model.dart';

import 'package:pos_parking/model/list_vehicle_response_model.dart';
import 'package:pos_parking/model/pay_parkir_response.dart';

class ParkirRepo {
  http_dio.Dio dio = http_dio.Dio();
  var addPlateUrl = "$apiUrl/api/vehicle/add";
  var listPlateUrl = "$apiUrl/api/vehicle/list";
  var createParkingPassUrl = "$apiUrl/api/parking_passes";

  Future<PayParkirResponse> addPlate(plateNo, token, passId) async {
    print(plateNo);
    print(token);
    http_dio.Response response;
    try {
      response = await dio.post(addPlateUrl,
          data: {"plate_number": plateNo},
          options: http_dio.Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          }));
      if (response.statusCode == 200) {
        AddVehicleResponse data = AddVehicleResponse.fromJson(response.data);
        return await createParkingPass(token, data.data.id, passId);
      }
    } on http_dio.DioError catch (error) {
      if (error.type == http_dio.DioErrorType.RESPONSE) {
        if (error.response.statusCode == 400) {
          return await vehicleList(token, plateNo, passId);
        }
      }
    }
  }

  Future vehicleList(token, plateNo, passId) async {
    http_dio.Response response;
    try {
      response = await dio.post(listPlateUrl,
          data: {},
          options: http_dio.Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          }));
      if (response.statusCode == 200) {
        ListVehicleResponse data = ListVehicleResponse.fromJson(response.data);
        for (var i = 0; i < data.response.plates.length; i++) {
          if (data.response.plates[i].plateNumber == plateNo) {
            print(data.response.plates[i].id);
            return await createParkingPass(
                token, data.response.plates[i].id, passId);
          }
        }
      }
    } on http_dio.DioError catch (error) {
      if (error.type == http_dio.DioErrorType.RESPONSE) {
        throw Exception();
      }
    }
  }

  Future createParkingPass(token, plateId, passId) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print(formattedDate);
    http_dio.Response response;
    try {
      response = await dio.post(createParkingPassUrl,
          data: {
            "start_date": formattedDate.toString(),
            "plate_id": plateId,
            "parking_pass_option_id": passId
          },
          options: http_dio.Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          }));
      if (response.statusCode == 200) {
        print("${response.data}");
        CreateParkirPassResponse data =
            CreateParkirPassResponse.fromJson(response.data);
        print(data.parkingPassId);
        return await payParkingPass(token, data.parkingPassId);
      }
    } on http_dio.DioError catch (error) {
      if (error.type == http_dio.DioErrorType.RESPONSE) {
        throw Exception();
      }
    }
  }

  Future payParkingPass(token, parkirPass) async {
    var payParkirUrl = "$apiUrl/api/parking_passes/$parkirPass/pay";
    http_dio.Response response;
    try {
      response = await dio.post(payParkirUrl,
          data: {},
          options: http_dio.Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          }));
      if (response.statusCode == 200) {
        print("${response.data}");
        PayParkirResponse data = PayParkirResponse.fromJson(response.data);
        print(data.status);
        return data;
      }
    } on http_dio.DioError catch (error) {
      if (error.type == http_dio.DioErrorType.RESPONSE) {
        if (error.response.statusCode == 400) {
          print(error.response.data);
        } else {
          throw Exception();
        }
      }
    }
  }
}
