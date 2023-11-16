import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:namma_bike/helper/api/api_headers.dart';
import 'package:namma_bike/helper/core/app_constant.dart';
import 'package:namma_bike/utility/dio_exception.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}

class ApiBaseHelper {
  static Future<dynamic> postAPICall(String url, Map<String, dynamic> param) async {
    final Dio dio = Dio();
    dynamic responseJson;
    try {
      print('response api*  ***$url********$param*********  response ');
      final response = await dio
          .post(url,
              data: FormData.fromMap(param.isNotEmpty ? param : {}),
              options: Options(
                headers: ApiHeader.headers,
              ))
          .timeout(
            const Duration(
              seconds: AppConstant.timeOut,
            ),
          );
      if (kDebugMode) {
        print(
            'response api****$url********$param*********  response   :${response.data}******************');
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseJson = response.data;
        return responseJson;
      } else {
        if (kDebugMode) {
          print(response.data.toString());
        }
      }
    } catch (e) {
      print(e.toString());
      DioExceptionhandler.errorHandler(e);
    }
  }

  static Future<dynamic> getAPICall(
      String url, Map<String, dynamic> param) async {
    final Dio dio = Dio();
    dynamic responseJson;
    try {
      print('response api****$url********$param*********  response ');
      final response = await dio
          .get(url,
              data: FormData.fromMap(param.isNotEmpty ? param : {}),
              options: Options(
                headers: ApiHeader.headers,
              ))
          .timeout(
            const Duration(
              seconds: AppConstant.timeOut,
            ),
          );
      if (kDebugMode) {
        print(
            'response api****$url********$param*********  response   :${response.data}******************');
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseJson = response.data;
        print("aaaaaaaaaaaaaaaaaaaaa$responseJson");
        return responseJson;
      } else {
        if (kDebugMode) {
          print(response.data.toString());
        }
      }
    } catch (e) {
      print(e.toString());
      DioExceptionhandler.errorHandler(e);
    }
  }
}
