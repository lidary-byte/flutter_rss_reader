import 'package:dio/dio.dart';

class DioManager {
  static final DioManager _instance = DioManager._internal();
  final Dio _dio = Dio();
  Dio get dio => _dio;

  // factory DioManager() {
  //   return _instance;
  // }

  DioManager._internal();

  static Dio getInstance() {
    return _instance._dio;
  }
}
