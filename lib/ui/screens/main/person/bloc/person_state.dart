part of 'person_bloc.dart';

// Person State Enum
enum PersonStatus { initial, success, error }

final class PersonState extends Equatable {
  final bool isLoading;
  final List<PersonModel> students;
  final List<PersonModel> relatives;
  final PersonRequest? personRequest;
  final PersonModel? personResponse;
  final PersonStatus status;
  final String? successMessage;
  final String? errorMessage;

  const PersonState({
    this.isLoading = false,
    this.students = const <PersonModel>[],
    this.relatives = const <PersonModel>[],
    this.personRequest,
    this.personResponse,
    this.status = PersonStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  PersonState copyWith({
    bool? isLoading,
    List<PersonModel>? students,
    List<PersonModel>? relatives,
    PersonRequest? personRequest,
    PersonModel? personResponse,
    PersonStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return PersonState(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
      relatives: relatives ?? this.relatives,
      personRequest: personRequest ?? this.personRequest,
      personResponse: personResponse ?? this.personResponse,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [isLoading, students];
}
