import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/request_model.dart';

import '../../constants/logger.dart';
import '../../constants/request_interceptor.dart';
import '../../constants/shared_prefs.dart';
import '../../space/model/space_model.dart';
import '../model/journal_model.dart';

var sl = GetIt.instance;

abstract class JournalApi {
  // Get All Journal
  Future<List<JournalModel>> getAllJournals();
  // Get One Journal
  Future<JournalModel> getOneJournal(String journalID);
  // Create Received Money Journal
  Future<List<JournalModel>> createReceivedMoneyJournal(
      List<ReceivedMoneyJournalRequest> journalRequests);
  // Create Payed Money Journal
  Future<List<JournalModel>> createPaidMoneyJournal(
      List<PaidMoneyJournalRequest> journalRequests);
  // Update Journal
  // Future<JournalModel> updateJournal(JournalRequest journalRequest);
  // Delete Journal
  Future<void> deleteJournal(String journalID);
}

class JournalApiImpl implements JournalApi {
  @override
  Future<List<JournalModel>> getAllJournals() async {
    try {
      // TODO: implement getAllTuitionFeess
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();
      Space? space = prefs.getSpaces().first;
      final res = await dio.get("/space/${space.id}/journal");
      if (res.statusCode == 200) {
        var response = res.data;

        if (response is Map && response['statusCode'] != null) {
          logger.d(response);
          throw Exception(response['message']);
        }
        List responseData = response;
        final List<JournalModel> journals =
            responseData.map((data) => JournalModel.fromJson(data)).toList();
        return journals;
      } else {
        throw Exception(res.data["message"]);
      }
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e("An error occurred: ${error.message}");
      // if (error.response != null) {
      //   throw Exception(error.response!.data["message"]);
      // }
      throw Exception("Error From DIO BACKEND");
    }
  }

  @override
  Future<JournalModel> getOneJournal(String journalID) async {
    // TODO: implement getOneTuitionFees
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.get("/space/1/journal/$journalID");
    if (res.statusCode == 200) {
      return JournalModel.fromJson(res.data);
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<List<JournalModel>> createReceivedMoneyJournal(
      List<ReceivedMoneyJournalRequest> tuitionFeesRequests) async {
    try {
      // TODO: implement createTuitionFees
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();
      Space? space = prefs.getSpaces().first;
      logger.i(tuitionFeesRequests.map((e) => e.toJson()));
      final res = await dio.post(
          "/space/${space.id}/transaction/received-money",
          data: tuitionFeesRequests.map((e) => e.toJson()).toList());
      if (res.statusCode == 201) {
        var response = res.data;
        if (response is Map &&
            !response.containsKey('statusCode') &&
            response['statusCode'] != null) {
          throw Exception(response['message']);
        }
        List responseData = response;
        List<JournalModel> tuitionFees =
            responseData.map((data) => JournalModel.fromJson(data)).toList();
        return tuitionFees;
      }
      logger.d(res.data);
      throw Exception(res.data["message"]);
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e("An error occurred: $error");
      if (error.response != null) {
        throw Exception(
            error.response?.data["message"] ?? "No Internet Connection");
      }
      throw Exception("Error From DIO BACKEND");
    }
  }

  @override
  Future<List<JournalModel>> createPaidMoneyJournal(
      List<PaidMoneyJournalRequest> tuitionFeesRequests) async {
    try {
      // TODO: implement createTuitionFees
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();
      Space? space = prefs.getSpaces().first;
      final res = await dio.post("/space/${space.id}/transaction/paid-money",
          data: tuitionFeesRequests.map((e) => e.toJson()).toList());
      if (res.statusCode == 201) {
        var response = res.data;
        if (response is Map &&
            !response.containsKey('statusCode') &&
            response['statusCode'] != null) {
          throw Exception(response['message']);
        }
        List responseData = response;
        List<JournalModel> tuitionFees =
            responseData.map((data) => JournalModel.fromJson(data)).toList();
        return tuitionFees;
      }
      logger.d(res.data);
      throw Exception(res.data["message"]);
    } on DioException catch (error) {
      // Handle Dio errors and other exceptions
      logger.e("An error occurred: $error");
      if (error.response != null) {
        throw Exception(
            error.response?.data["message"] ?? "No Internet Connection");
      }
      throw Exception("Error From DIO BACKEND");
    }
  }

  @override
  Future<void> deleteJournal(String journalID) async {
    // TODO: implement deleteTuitionFees
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    final res = await dio.delete("/space/${space.id}/transaction/$journalID");
    if (res.statusCode == 200) {
      return;
    }
    throw Exception(res.data["message"]);
  }
}
