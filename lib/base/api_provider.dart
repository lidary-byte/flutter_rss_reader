import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();
  final Dio _dio = Dio();
  Dio get dio => _dio;

  factory ApiProvider() {
    return _instance;
  }

  ApiProvider._internal() {
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
