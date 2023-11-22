part of 'groups_bloc.dart';

enum GroupStateStatus {
  initial,
  success,
  error,
}

class GroupsState {
  final GroupStateStatus status;
  final GroupRequest? groupRequest;
  final List<Group>? groups;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const GroupsState({
    this.status = GroupStateStatus.initial,
    this.groupRequest,
    this.groups,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  GroupsState copyWith({
    GroupStateStatus? status,
    GroupRequest? groupRequest,
    List<Group>? groups,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return GroupsState(
      status: status ?? this.status,
      groupRequest: groupRequest ?? this.groupRequest,
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
