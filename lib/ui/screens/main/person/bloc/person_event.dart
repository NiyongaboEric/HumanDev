part of 'person_bloc.dart';

sealed class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

final class GetAllPersonEvent extends PersonEvent {
  const GetAllPersonEvent();
}

final class GetOnePersonEvent extends PersonEvent {
  final String personID;
  const GetOnePersonEvent(this.personID);
}

final class GetRelativesEvent extends PersonEvent {
  final String personID;
  const GetRelativesEvent(this.personID);
}

final class AddPersonEvent extends PersonEvent {
  final PersonRequest personRequest;
  const AddPersonEvent(this.personRequest);
}

final class UpdatePersonEvent extends PersonEvent {
  final UpdatePersonRequest persons;
  const UpdatePersonEvent(this.persons);
}

final class GetAdminEvent extends PersonEvent {
  const GetAdminEvent();
}

final class GetStudentsWithPendingPaymentsEvent extends PersonEvent {
  const GetStudentsWithPendingPaymentsEvent();
}

// Reset State Event
final class ResetPersonStateEvent extends PersonEvent {
  const ResetPersonStateEvent();
}