import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/data/space/model/space_model.dart';

import '../../constants/request_interceptor.dart';
import '../model/person_request.dart';

var sl = GetIt.instance;

// var studentId =

abstract class PersonApi {
  // Create person
  Future<PersonModel> createPerson(PersonRequest personRequest);
  // Get All Persons
  Future<List<PersonModel>> getAllPersons();
  // Get One Person
  Future<PersonModel> getOnePerson(String studentID);
  // Get relatives
  Future<List<PersonModel>> getRelatives(String studentID);
}

class PersonApiImpl implements PersonApi {
  @override
  Future<PersonModel> createPerson(PersonRequest personRequest) async {
    try {
      // TODO: implement createStudent
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();
      Space? space = prefs.getSpaces().first;
      final res = await dio.post("/space/${space.id}/person",
          data: personRequest.toJson());
      if (res.statusCode == 201) {
        return PersonModel.fromJson(res.data);
      } else {
        throw Exception(res.data["message"]);
      }
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e(
          "An error occurred: ${error.response?.data["message"] ?? "No internet connectivity"}");
      throw Exception(
          error.response?.data["message"] ?? "No internet connectivity");
    }
  }

  @override
  Future<List<PersonModel>> getAllPersons() async {
    try {
      // TODO: implement get students
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();

      Space? space = prefs.getSpaces().first;
      final res = await dio.get("/space/${space.id}/persons");
      if (res.statusCode == 200) {
        var response = res.data;

        if (response is Map && response['statusCode'] != null) {
          logger.d(response);
          throw Exception(response['message']);
        }
        // logger.d(response);
        List responseData = response;
        final List<PersonModel> students =
            responseData.map((data) => PersonModel.fromJson(data)).toList();
        return students;
      } else {
        // Handle non-200 status codes
        logger.e("Request failed with status: ${res.statusCode}");
        throw Exception(res.data["message"]);
      }
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      throw Exception(
          error.response?.data["message"] ?? "No Internet Connectivity");
    }
  }

  @override
  Future<PersonModel> getOnePerson(String studentID) async {
    //    print("Get one student api called.");
    var interceptor = sl.get<RequestInterceptor>();
    var dio = Dio()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();

    Space? space = prefs.getSpaces().first;
    final res = await dio.get("/space/${space.id}/person/$studentID");
    if (res.statusCode == 200) {
      return PersonModel.fromJson(res.data);
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<List<PersonModel>> getRelatives(String studentID) async {
    try {
      // TODO: implement getRelatives
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();

      Space? space = prefs.getSpaces().first;
      final res = await dio
          .get("/space/${space.id}/person/$studentID/relatives", data: {
        "spaceId": 1,
        "id": studentID,
      });
      logger.d(res.data);
      if (res.statusCode == 200) {
        var response = res.data;

        if (response is Map && response['statusCode'] != null) {
          logger.d(response);
          throw Exception(response['message']);
        }
        // logger.d(response);
        List responseData = response;
        final List<PersonModel> students =
            responseData.map((data) => PersonModel.fromJson(data)).toList();
        return students;
      } else {
        // Handle non-200 status codes
        logger.e("Request failed with status: ${res.statusCode}");
        throw Exception(res.data["message"]);
      }
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e("An error occurred: ${error.response!.data["message"]}");
      throw Exception(error);
    }
  }
}
