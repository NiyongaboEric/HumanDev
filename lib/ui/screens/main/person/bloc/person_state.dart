part of 'person_bloc.dart';

// Person State Enum
enum PersonStatus { initial, success, error }

final class PersonState extends Equatable {
  final bool isLoading;
  final List<PersonModel> persons;
  final List<PersonModel> relatives;
  final PersonRequest? personRequest;
  final List<PersonModel>? personResponse;
  final PersonModel? schoolAdmin;
  final PersonStatus status;
  final String? successMessage;
  final String? errorMessage;

  const PersonState({
    this.isLoading = false,
    this.persons = const <PersonModel>[],
    this.relatives = const <PersonModel>[],
    this.personRequest,
    this.personResponse,
    this.schoolAdmin,
    this.status = PersonStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  PersonState copyWith({
    bool? isLoading,
    List<PersonModel>? persons,
    List<PersonModel>? relatives,
    PersonRequest? personRequest,
    List<PersonModel>? personResponse,
    PersonModel? schoolAdmin,
    PersonStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return PersonState(
      isLoading: isLoading ?? this.isLoading,
      persons: persons ?? this.persons,
      relatives: relatives ?? this.relatives,
      personRequest: personRequest ?? this.personRequest,
      personResponse: personResponse ?? this.personResponse,
      schoolAdmin: schoolAdmin ?? this.schoolAdmin,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [isLoading, persons];
}
