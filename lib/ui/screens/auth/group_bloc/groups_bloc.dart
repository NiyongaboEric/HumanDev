import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';

import '../../../../data/groups/api/group_api.dart';
import '../../../../data/groups/model/group_model.dart';
import '../../../../data/groups/model/group_request.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final SharedPreferenceModule sharedPreferenceModule;
  final GroupApiImpl groupApiImpl;
  GroupsBloc(this.sharedPreferenceModule, this.groupApiImpl) : super(const GroupsState()) {
    on<GroupsEventGetGroups>(_getGroups);
    on<GroupsEventCreateGroup>(_createGroup);
  }

  Future<void> _getGroups(
      GroupsEventGetGroups event, Emitter<GroupsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final groups = await groupApiImpl.getGroups();
      sharedPreferenceModule.saveGroups(groups);
      logger.i("Status: ${state.isLoading}");
      emit(state.copyWith(
        status: GroupStateStatus.success,
        groups: groups,
        isLoading: false,
        successMessage: "Request Successful",
      ));
      logger.i("Status: ${state.isLoading}");
    } on DioException catch (error) {
      emit(state.copyWith(
        errorMessage:
            error.response?.data['message'] ?? "No internet connection",
        isLoading: false,
        status: GroupStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        status: GroupStateStatus.initial,
        errorMessage: null,
        successMessage: null,
        isLoading: false,
        groupRequest: null,
      ));
    }
  }

  Future<void> _createGroup(
      GroupsEventCreateGroup event, Emitter<GroupsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final group = await groupApiImpl.createGroup(event.groupRequest);
      sharedPreferenceModule.saveGroup(group);
      emit(state.copyWith(
        status: GroupStateStatus.createSuccess,
        groupResponse: group,
        isLoading: false,
        successMessage: "Group created successfully",
        groupRequest: null,
      ));
    } on DioException catch (error) {
      emit(state.copyWith(
        errorMessage:
            error.response?.data['message'] ?? "No internet connection",
        isLoading: false,
        status: GroupStateStatus.createError,
        groupRequest: event.groupRequest,
      ));
    } finally {
      emit(state.copyWith(
        status: GroupStateStatus.initial,
        errorMessage: null,
        successMessage: null,
        isLoading: false,
      ));
    }
  }
}
