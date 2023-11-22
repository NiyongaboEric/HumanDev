import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_request.dart';

import '../../constants/request_interceptor.dart';
import '../../constants/shared_prefs.dart';
import '../../space/model/space_model.dart';

var sl = GetIt.instance;

abstract class GroupApi {
  // Get Groups
  Future<List<Group>> getGroups();
  // Create Group
  Future<Group> createGroup(GroupRequest groupRequest);
}

class GroupApiImpl implements GroupApi {

  @override
  Future<List<Group>> getGroups() async{
    // TODO: implement getGroups
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    final res = await dio.get("/space/${space.id}/group");
    if (res.statusCode == 200) {
      var response = res.data;
      return List<Group>.from(response.map((group) => Group.fromJson(group)));
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<Group> createGroup(GroupRequest groupRequest) async {
    // TODO: implement createGroup
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    final res = await dio.post("/space/${space.id}/group", data: groupRequest.toJson());
    if (res.statusCode == 200) {
      return Group.fromJson(res.data);
    }
    throw Exception(res.data["message"]);
  }
}
