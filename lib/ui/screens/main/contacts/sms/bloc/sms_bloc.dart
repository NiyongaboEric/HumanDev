import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';

part 'sms_event.dart';
part 'sms_state.dart';

class SMSBloc extends Bloc<SMSEvent, SMSState> {

  SMSBloc() : super(const SMSState()) {
    on<SaveDataSendSMSState>(_saveDataSendSMS);
  }

  // Save Data
  _saveDataSendSMS(SaveDataSendSMSState event, Emitter<SMSState> emit) {
    try {
      emit(state.copyWith(
        reminderRequest: event.reminderRequest,
        recipients: event.recipients,
        status: SMSStateStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        status: SMSStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: SMSStateStatus.initial,
        errorMessage: null,
      ));
    }
  }
}
