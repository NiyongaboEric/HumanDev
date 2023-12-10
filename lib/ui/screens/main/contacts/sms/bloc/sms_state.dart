part of 'sms_bloc.dart';

enum SMSStateStatus {
  initial,
  success,
  error
}

class SMSState {
  final bool isLoading;
  final SMSStateStatus status;
  final String? successMessage;
  final String? errorMessage;
  final List<String>? recipients;
  final ReminderRequest? reminderRequest;

  const SMSState({
    this.isLoading = false,
    this.status = SMSStateStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.reminderRequest,
    this.recipients = const <String>[],
  });

  SMSState copyWith({
    bool? isLoading,
    SMSStateStatus? status,
    String? successMessage,
    String? errorMessage,
    List<String>? recipients, ReminderRequest? reminderRequest,
  }) {
    return SMSState(
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      recipients: recipients ?? this.recipients,
      reminderRequest: reminderRequest ?? this.reminderRequest,
    );
  }
}
