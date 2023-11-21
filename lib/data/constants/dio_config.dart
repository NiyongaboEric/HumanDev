import 'package:dio/dio.dart';

import './request_interceptor.dart';

class DioConfig {
  final Dio _dio = Dio();
  final String _baseUrl = "https://backdev.pay.seymo.ai";
  final RequestInterceptor requestInterceptor;

  DioConfig({required this.requestInterceptor});

  BaseOptions _dioOptions() {
    BaseOptions opts = BaseOptions();
    opts.baseUrl = _baseUrl;
    opts.connectTimeout = const Duration(milliseconds: 60000);
    opts.receiveTimeout = const Duration(milliseconds: 60000);
    opts.sendTimeout = const Duration(milliseconds: 60000);
    return opts;
  }

  Dio provideDio() {
    _dio.options = _dioOptions();
    _dio.interceptors.add(requestInterceptor);
    return _dio;
  }
}