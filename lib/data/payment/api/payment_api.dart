import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../constants/logger.dart';
import '../../constants/request_interceptor.dart';
import '../../constants/shared_prefs.dart';
import '../../space/model/space_model.dart';
import '../model/payment_model.dart';
import '../model/requst_model.dart';

var sl = GetIt.instance;

var prefs = sl<SharedPreferenceModule>();

Space? space = prefs.getSpaces().first;

abstract class PaymentApi {
  // Get All TuitionFees
  Future<List<PaymentModel>> getAllPayment();
  // Get One TuitionFees
  Future<PaymentModel> getOnePayment(String PaymentID);
  // Create TuitionFees
  Future<PaymentModel> createPayment(PaymentRequest Payment);
  // Update TuitionFees
  Future<PaymentModel> updatePayment(PaymentRequest Payment);
  // Delete TuitionFees
  Future<void> deletePayment(String PaymentID);
}

class PaymentApiImpl implements PaymentApi {
  @override
  Future<List<PaymentModel>> getAllPayment() async {
    try {
      // TODO: implement getAllTuitionFeess
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      final res = await dio.get("/space/${space?.id}/journal");
      if (res.statusCode == 200) {
        var response = res.data;
        return List<PaymentModel>.from(
            response["payments"].map((e) => PaymentModel.fromJson(e)));
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
  Future<PaymentModel> getOnePayment(String PaymentID) async {
    // TODO: implement getOneTuitionFees
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.get("/space/${space?.id}/journal/$PaymentID");
    if (res.statusCode == 200) {
      return PaymentModel.fromJson(res.data);
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<PaymentModel> createPayment(PaymentRequest Payment) async {
    try {
      // TODO: implement createTuitionFees
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      final res = await dio.post("/space/1/journal", data: Payment.toJson());
      if (res.statusCode == 201) {
        var response = res.data;
        return PaymentModel.fromJson(response);
      }
      throw Exception(res.data["message"]);
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
  Future<PaymentModel> updatePayment(PaymentRequest Payment) async {
    try {
      // TODO: implement createTuitionFees
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      final res = await dio.patch("/space/${space?.id}/journal/${Payment.id}",
          data: Payment.toJson());
      if (res.statusCode == 201) {
        var response = res.data;
        return PaymentModel.fromJson(response);
      }
      throw Exception(res.data["message"]);
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
  Future<void> deletePayment(String PaymentID) async {
    // TODO: implement deleteTuitionFees
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.delete("/space/${space?.id}/journal/$PaymentID");
    if (res.statusCode == 200) {
      return;
    }
    throw Exception(res.data["message"]);
  }
}
