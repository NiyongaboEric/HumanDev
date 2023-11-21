import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_model.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';

import '../../constants/logger.dart';
import '../../constants/request_interceptor.dart';
import '../../constants/shared_prefs.dart';
import '../../space/model/space_model.dart';

var sl = GetIt.instance;


abstract class ReminderApi {
  Future<ReminderModel> createReminder(ReminderRequest reminderRequest);
}

class ReminderApiImpl implements ReminderApi {
  @override
  Future<ReminderModel> createReminder(ReminderRequest reminderRequest) async {
    // TODO: implement createReminder
    try {
      var interceptor = sl.get<RequestInterceptor>();
      var dio = sl.get<Dio>()..interceptors.add(interceptor);
      var prefs = sl<SharedPreferenceModule>();
      Space? space = prefs.getSpaces().first;
      final res = await dio.post("/space/${space.id}/reminder",
          data: reminderRequest.toJson());
      logger.d(res.data);
      if (res.statusCode == 201) {
        return ReminderModel.fromJson(res.data[0]);
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
}
