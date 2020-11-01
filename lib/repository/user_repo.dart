import 'package:dio/dio.dart' as http_dio;
import 'package:flutter/material.dart';
import 'package:pos_parking/config/constants.dart';
import 'package:pos_parking/model/user_response_model.dart';

class UserRepository {
  http_dio.Dio dio = http_dio.Dio();
  var userLoginUrl = "$apiUrl/api/users/login";

  Future<UserResponse> login(email, password) async {
    http_dio.Response response;
    try {
      response = await dio.post(userLoginUrl,
          data: {"email": email, "password": password},
          options: http_dio.Options(headers: {
            "Content-Type": "application/json",
          }));
      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on http_dio.DioError catch (error) {
      if (error.type == http_dio.DioErrorType.RESPONSE) {
        if (error.response.statusCode == 400) {
          throw Exception();
          // UserResponseError errorResponse =
          //     UserResponseError.fromJson(error.response.data);
          // final snackBar = SnackBar(
          //     backgroundColor: Colors.red, content: Text(errorResponse.status));
          // Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    }
  }
}
