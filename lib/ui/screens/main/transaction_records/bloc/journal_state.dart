part of 'journal_bloc.dart';

// Journal State Enum
enum JournalStatus { initial, success, error }

final class JournalState {
  final bool isLoading;
  final JournalModel? journalData;
  final List<JournalModel>? journals;
  final PersonModel? recipient;
  final JournalStatus status;
  final String? successMessage;
  final String? errorMessage;

  const JournalState({
    this.isLoading = false,
    this.journalData = const JournalModel(),    
    this.journals = const <JournalModel>[],
    this.recipient,
    this.status = JournalStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  JournalState copyWith({
    bool? isLoading,
    JournalModel? journalData,
    List<JournalModel>? journals,
    JournalStatus? status,
    PersonModel? recipient,
    String? successMessage,
    String? errorMessage,
  }) {
    return JournalState(
      isLoading: isLoading ?? this.isLoading,
      journalData: journalData ?? this.journalData,
      journals: journals ?? this.journals,
      recipient: recipient ?? this.recipient,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
