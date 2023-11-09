import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/journal/api/tuition_fees_api.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/request_model.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/journal_model.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalApiImpl journalApiImpl;
  JournalBloc(this.journalApiImpl) : super(const JournalState()) {
    on<GetAllJournalEvent>(_getAllJournals);
    on<AddNewJournalEvent>(_addNewJournal);
    // on<UpdateJournalEvent>(_updateJournal);
    on<DeleteJournalEvent>(_deleteJournal);
    on<SaveDataJournalState>(_saveData);
    on<ClearDataJournalState>(_clearData);
  }

  Future _getAllJournals(
      GetAllJournalEvent event, Emitter<JournalState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final journals = await journalApiImpl.getAllJournals();
      emit(state.copyWith(
        journals: journals,
        isLoading: false,
        status: JournalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: JournalStatus.error,
      ));
    }
  }

  Future _addNewJournal(
      AddNewJournalEvent event, Emitter<JournalState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final journals =
          await journalApiImpl.createJournal(event.journalRequest);
      emit(state.copyWith(
        journals: journals,
        successMessage: "Record successfully saved",
        isLoading: false,
        status: JournalStatus.success,
      ));
      emit(state.copyWith(
        isLoading: false,
        status: JournalStatus.initial,
        successMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: JournalStatus.error,
      ));
      emit(state.copyWith(
        errorMessage: null,
        status: JournalStatus.initial,
      ));
    }
  }

  // Future _getOneJournal(
  //     GetOneJournalEvent event, Emitter<JournalState> emit) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final journal = await journalApiImpl.getOneJournal(event.journalID);
  //     emit(state.copyWith(
  //       // journal: journal,
  //       isLoading: false,
  //       status: JournalStatus.success,
  //     ));
  //   } catch (error) {
  //     emit(state.copyWith(
  //       errorMessage: error.toString(),
  //       isLoading: false,
  //       status: JournalStatus.error,
  //     ));
  //   }
  // }

  // Future _updateJournal(
  //     UpdateJournalEvent event, Emitter<JournalState> emit) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final journal =
  //         await journalApiImpl.updateJournal(event.journalRequest);
  //     emit(state.copyWith(
  //       journals: [journal],
  //       // journal: journal,
  //       isLoading: false,
  //       successMessage: "Record successfully updated",
  //       status: JournalStatus.success,
  //       // status: JournalStatus.success,
  //     ));
  //   } catch (error) {
  //     emit(state.copyWith(
  //       errorMessage: error.toString(),
  //       isLoading: false,
  //       status: JournalStatus.error,
  //       // status: JournalStatus.error,
  //     ));
  //     emit(state.copyWith(
  //       errorMessage: null,
  //       status: JournalStatus.initial,
  //     ));
  //   }
  // }

  Future _deleteJournal(
      DeleteJournalEvent event, Emitter<JournalState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await journalApiImpl.deleteJournal(event.journalID);
      emit(state.copyWith(
        isLoading: false,
        successMessage: "Record Successfully Deleted",
        status: JournalStatus.success,
        // status: JournalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: JournalStatus.error,
        // status: JournalStatus.error,
      ));
    }
  }

  // Save Data
  _saveData(SaveDataJournalState event, Emitter<JournalState> emit) {
    try {
      emit(state.copyWith(
          journalData: event.journalData,
          status: JournalStatus.success,
          successMessage: "Data saved successfully"));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        status: JournalStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: JournalStatus.initial,
        errorMessage: null,
        successMessage: null,
      ));
    }
  }

  // Clear Data
  _clearData(ClearDataJournalState event, Emitter<JournalState> emit) {
    try {
      emit(state.copyWith(
        journalData: null,
        status: JournalStatus.success,
        successMessage: "Data cleared successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        status: JournalStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: JournalStatus.initial,
        errorMessage: null,
        successMessage: null,
      ));
    }
  }
}
