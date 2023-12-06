part of 'sms_bloc.dart';

sealed class SMSEvent extends Equatable {
  const SMSEvent();

  @override
  List<Object> get props => [];
}

class SaveDataSendSMSState extends SMSEvent {
  final ReminderRequest? reminderRequest;
  final List<String>? recipients;
  

  const SaveDataSendSMSState(
    this.reminderRequest,
    this.recipients
  );
}
