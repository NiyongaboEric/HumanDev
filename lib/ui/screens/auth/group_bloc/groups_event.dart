part of 'groups_bloc.dart';

sealed class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class GroupsEventGetGroups extends GroupsEvent {
  const GroupsEventGetGroups();
}

class GroupsEventCreateGroup extends GroupsEvent {
  final GroupRequest groupRequest;

  const GroupsEventCreateGroup(this.groupRequest);
}
