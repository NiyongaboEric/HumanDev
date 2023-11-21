part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class GetAllReminderEvent extends ReminderEvent {
  const GetAllReminderEvent();
}

class AddNewReminderEvent extends ReminderEvent {
  final ReminderRequest reminderRequest;

  const AddNewReminderEvent(this.reminderRequest);
}

class UpdateReminderEvent extends ReminderEvent {
  final ReminderModel reminderModel;

  const UpdateReminderEvent(this.reminderModel);
}

class DeleteReminderEvent extends ReminderEvent {
  final String reminderID;

  const DeleteReminderEvent(this.reminderID);
}

class SaveDataReminderState extends ReminderEvent {
  final ReminderRequest? reminderRequest;
  final List<String>? recipients;

  const SaveDataReminderState(
    this.reminderRequest,
    this.recipients,);
}

class ClearDataReminderState extends ReminderEvent {
  const ClearDataReminderState();
}
