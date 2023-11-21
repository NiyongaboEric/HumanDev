import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/reminders/api/reminder_api.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_model.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderApiImpl reminderApiImpl;
  ReminderBloc(this.reminderApiImpl) : super(const ReminderState()) {
    on<AddNewReminderEvent>(_addNewReminder);
    // on<GetAllReminderEvent>(_getAllReminder);
    on<SaveDataReminderState>(_saveData);
    on<ClearDataReminderState>(_clearData);
  }

  // Add New Reminder
  _addNewReminder(
      AddNewReminderEvent event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final reminder =
          await reminderApiImpl.createReminder(event.reminderRequest);
      emit(state.copyWith(
        reminders: [reminder],
        isLoading: false,
        status: ReminderStateStatus.success,
        successMessage: "Reminder successfully sent",
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: ReminderStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: ReminderStateStatus.initial,
        errorMessage: null,
        successMessage: null,
      ));
    }
  }

  // Save Data
  _saveData(SaveDataReminderState event, Emitter<ReminderState> emit) {
    try {
      emit(state.copyWith(
        reminderRequest: event.reminderRequest,
        recipients: event.recipients,
        status: ReminderStateStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        status: ReminderStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: ReminderStateStatus.initial,
        errorMessage: null,
      ));
    }
  }

  // Clear Data
  _clearData(ClearDataReminderState event, Emitter<ReminderState> emit) async {
    try {
      emit(state.copyWith(
        reminderRequest: null,
        status: ReminderStateStatus.initial,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        status: ReminderStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        status: ReminderStateStatus.initial,
        errorMessage: null,
      ));
    }
  }
}
