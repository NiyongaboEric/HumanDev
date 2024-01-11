import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/person/api/person_api.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';

import '../../../../../data/person/model/person_request.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonApiImpl studentApiImpl;
  final SharedPreferenceModule prefs;
  PersonBloc(this.studentApiImpl, this.prefs) : super(const PersonState()) {
    on<GetAllPersonEvent>(_getAllStudents);
    // on<GetOnePersonEvent>(_getOneStudent);
    // on<GetRelativesEvent>(_getRelatives);
    on<AddPersonEvent>(_addPerson);
    on<UpdatePersonEvent>(_updatePerson);
    on<GetAdminEvent>(_getAdmin);
    on<GetStudentsWithPendingPaymentsEvent>(_getStudentsWithPendingPayments);
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
          // successMessage: "Request successful",
        ),
      );
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
          // successMessage: "Request Successful",
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
          // successMessage: "Request Successful",
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

  // Update Person
  Future _updatePerson(
    UpdatePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final persons = await studentApiImpl.updatePerson(event.persons);
      Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(
        isLoading: false,
        status: PersonStatus.success,
        personResponse: persons,
        successMessage: "Person updated successfully",
      ));
      emit(state.copyWith(
        status: PersonStatus.initial,
        errorMessage: null,
        successMessage: null,
        personRequest: null,
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
        successMessage: null,
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

  // Get Admin
  Future _getAdmin(
    GetAdminEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final admin = await studentApiImpl.getAdmin();
      prefs.saveAdmin(admin);
      emit(state.copyWith(
        isLoading: false,
        status: PersonStatus.success,
        schoolAdmin: admin,
        // successMessage: "Request Successful",
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

  // Get Students with pending payments
  Future _getStudentsWithPendingPayments(
    GetStudentsWithPendingPaymentsEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final students = await studentApiImpl.getAllStudentsWithPendingPayments();
      emit(
        state.copyWith(
          persons: students,
          isLoading: false,
          status: PersonStatus.success,
          // successMessage: "Request Successful",
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
}
