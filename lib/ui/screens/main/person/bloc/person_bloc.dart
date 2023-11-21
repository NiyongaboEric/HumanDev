import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/person/api/person_api.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_request.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonApiImpl studentApiImpl;
  PersonBloc(this.studentApiImpl) : super(const PersonState()) {
    on<GetAllPersonEvent>(_getAllStudents);
    // on<GetOnePersonEvent>(_getOneStudent);
    // on<GetRelativesEvent>(_getRelatives);
    on<AddPersonEvent>(_addPerson);
  }

  Future _getAllStudents(
    GetAllPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final persons = await studentApiImpl.getAllPersons();
      emit(
        state.copyWith(
          persons: persons,
          isLoading: false,
          status: PersonStatus.success,
          successMessage: "Request successful",
        ),
      );
      emit(state.copyWith(
        status: PersonStatus.initial,
        successMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: PersonStatus.error,
      ));
      emit(state.copyWith(
        status: PersonStatus.initial,
        errorMessage: null,
      ));
    }
  }

  Future _getOneStudent(
    GetOnePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final persons = await studentApiImpl.getOnePerson(event.personID);
      emit(
        state.copyWith(
          // student: student,
          isLoading: false,
          status: PersonStatus.success,
          successMessage: "Request Successful",
        ),
      );
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: PersonStatus.error,
      ));
      emit(state.copyWith(
        status: PersonStatus.initial,
        errorMessage: null,
      ));
    }
  }

  Future _getRelatives(
    GetRelativesEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final relatives = await studentApiImpl.getRelatives(event.personID);
      emit(
        state.copyWith(
          relatives: relatives,
          isLoading: false,
          status: PersonStatus.success,
          successMessage: "Request Successful",
        ),
      );
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: PersonStatus.error,
      ));
      emit(state.copyWith(
        status: PersonStatus.initial,
        errorMessage: null,
      ));
    }
  }

  // Add Person
  Future _addPerson(
    AddPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final person = await studentApiImpl.createPerson(event.personRequest);
      emit(state.copyWith(
        isLoading: false,
        status: PersonStatus.success,
        personResponse: person,
        successMessage: "Person created successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: PersonStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        status: PersonStatus.initial,
        errorMessage: null,
        successMessage: null,
        isLoading: false,
        personRequest: null,
      ));
    }
  }
}
