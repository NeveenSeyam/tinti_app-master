import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../Helpers/failure.dart';
import '../Util/constants/constants.dart';
import '../helpers/ui_helper.dart';

class BaseDioApi {
  //! we just init the dio object for once and use it in all the apis
  final Dio _dio = Dio();
  late Response _response;
  //! the url of the api we get it form constrctor
  final String url;
  BaseDioApi(this.url);

  Map<String, dynamic> queryParameters() {
    return {};
  }

//! body we can use it like override it in the child class
  dynamic body() {}

//*  here we add All request types

  Future<Map<String, dynamic>> postRequest() async {
    debugPrint('url $url');
    debugPrint('body ${body()}');

    try {
      _response = await _dio.post(
        url,
        options: Options(
          //*! here we can add the headers if we need it

          headers: {
            'Content-Type': 'application/json',
            'os': 'ios',
            'language': 'ar',
            "Authorization": "Bearer ${Constants.token}"
          },
        ),
        queryParameters: queryParameters(),
        data: body(),
      );

      return _response.data;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("${e.response}");
      debugPrint(e.message);
      UIHelper.showNotification(e.response?.data['message'] ?? 'خطأ');

      //   UIHelper.showNotification(e.response!.data['message']);

      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          debugPrint(e.response?.statusMessage);
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }

  Future<dynamic> getRequest() async {
    debugPrint('url $url');
    debugPrint('queryParameters ${queryParameters()}');
    try {
      _response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'device_id': '123456789',
            'os': 'ios',
            "Authorization": "Bearer ${Constants.token}",
            'Accept-Language': '${Constants.lang}',
          },
        ),
        queryParameters: queryParameters(),
      );
      debugPrint('_response.data ${_response.data}');

      return _response.data;
    } on DioError catch (e) {
      // UIHelper.showNotification(" ${e.response}");
      log(" ${e.response?.data}");
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          debugPrint(e.response?.statusMessage);
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }

  Future<Map<String, dynamic>> putRequest() async {
    try {
      _response = await _dio.put(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'device_id': '123456789',
            'os': 'ios',
            "Authorization": "Bearer ${Constants.token}",
            'language': 'ar',
          },
        ),
        queryParameters: queryParameters(),
        data: body(),
      );
      return _response.data;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }

  Future<Map<String, dynamic>> deleteRequest() async {
    try {
      _response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'device_id': '123456789',
            'os': 'ios',
            "Authorization": "Bearer ${Constants.token}",
            'language': 'ar',
          },
        ),
        queryParameters: queryParameters(),
        data: body(),
      );
      return _response.data;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }
}
