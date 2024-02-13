import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../constants/logger.dart';
import '../../constants/request_interceptor.dart';
import '../../constants/shared_prefs.dart';
import '../../space/model/space_model.dart';
import '../model/account_model.dart';

var sl = GetIt.instance;

abstract class AccountApi {
  // Get Accounts
  Future<List<AccountsModel>> getAccounts();
}

class AccountApiImpl implements AccountApi {
  @override
  Future<List<AccountsModel>> getAccounts() async {
    // TODO: implement getAccounts
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    final res = await dio.get("/space/${space.id}/account");
    if (res.statusCode == 200) {
      var response = res.data;
      // if (response is Map && response['statusCode'] != null) {
      //   logger.d(response);
      //   throw Exception(response['message']);
      // }
      List responseData = response;
      final List<AccountsModel> accounts =
          responseData.map((data) => AccountsModel.fromJson(data)).toList();
      return accounts;
    }
    logger.d(res.data);
    throw Exception(res.data["message"]);
  }
}
