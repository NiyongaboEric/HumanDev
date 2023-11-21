part of 'reminder_bloc.dart';

enum ReminderStateStatus {
  initial,
  success,
  error,
}

class ReminderState {
  final bool isLoading;
  final ReminderStateStatus status;
  final String? successMessage;
  final String? errorMessage;
  final ReminderRequest? reminderRequest;
  final List<ReminderModel>? reminders;
  final List<String>? recipients;

  const ReminderState({
    this.isLoading = false,
    this.status = ReminderStateStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.reminderRequest,
    this.reminders = const <ReminderModel>[],
    this.recipients = const <String>[],
  });

  ReminderState copyWith({
    bool? isLoading,
    ReminderStateStatus? status,
    String? successMessage,
    String? errorMessage,
    ReminderRequest? reminderRequest,
    List<ReminderModel>? reminders,
    List<String>? recipients,
  }) {
    return ReminderState(
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      reminderRequest: reminderRequest ?? this.reminderRequest,
      reminders: reminders ?? this.reminders,
      recipients: recipients ?? this.recipients,
    );
  }
}
