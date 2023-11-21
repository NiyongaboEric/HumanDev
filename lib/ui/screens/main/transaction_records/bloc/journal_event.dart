part of 'journal_bloc.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class GetAllJournalEvent extends JournalEvent {
  const GetAllJournalEvent();
}

class AddNewJournalEvent extends JournalEvent {
  final JournalRequest journalRequest;

  const AddNewJournalEvent(this.journalRequest);
}

class UpdateJournalEvent extends JournalEvent {
  final JournalRequest journalRequest;

  const UpdateJournalEvent(this.journalRequest);
}

class DeleteJournalEvent extends JournalEvent {
  final String journalID;

  const DeleteJournalEvent(this.journalID);
}

class SaveDataJournalState extends JournalEvent {
  final JournalModel journalData;

  const SaveDataJournalState(this.journalData);
}

class ClearDataJournalState extends JournalEvent {
  const ClearDataJournalState();
}