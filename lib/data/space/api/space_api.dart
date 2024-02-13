import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';

import '../../constants/logger.dart';
import '../../constants/request_interceptor.dart';
import '../model/space_model.dart';

GetIt sl = GetIt.instance;

abstract class SpaceApi {
  Future<List<Space>> getSpaces();
  // Update Space
  Future<Space> updateSpace(String name);
}

class SpaceApiImpl implements SpaceApi {
  @override
  Future<List<Space>> getSpaces() async {
    try {
      // TODO: implement getSpace
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      final res = await dio.get("/space");
      logger.i(res.data);
      if (res.statusCode == 200) {
        var response = res.data;

        if (response is Map && response['statusCode'] != null) {
          logger.d(response);
          throw Exception(response['message']);
        }
        // logger.d(response);
        List responseData = response;
        logger.d(Space.fromJson(responseData.first).toJson());
        final List<Space> spaces = responseData.map((data) {
          // logger.f(data);
          return Space.fromJson(data);
        }).toList();
        return spaces;
      } else {
        // Handle non-200 status codes
        logger.e("Request failed with status: ${res.statusCode}");
        throw Exception(res.data["message"]);
      }
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e(
          "An error occurred: ${error.response?.data["message"] ?? "No internet connection"}");
      throw Exception(
          error.response?.data["message"] ?? "No internet connection");
    }
  }

  @override
  Future<Space> updateSpace(String name) async {
    var prefs = sl<SharedPreferenceModule>();
    var spaceID = prefs.getSpaces().first.id;
    try {
      // TODO: implement getSpace
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      final res = await dio.patch("/space/$spaceID", data: {"name": name});
      if (res.statusCode == 200 || res.statusCode == 202) {
        var response = res.data;

        if (response is Map && response['statusCode'] != null) {
          logger.d(response);
          throw Exception(response['message']);
        }
        final Space space = Space.fromJson(response);
        return space;
      } else {
        // Handle non-200 status codes
        logger.e("Request failed with status: ${res.statusCode}");
        throw Exception(res.data["message"]);
      }
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e(
          "An error occurred: ${error.response?.data["message"] ?? "Network Error"}");
      throw Exception(error.response?.data["message"] ?? "Network Error");
    }
  }
}
