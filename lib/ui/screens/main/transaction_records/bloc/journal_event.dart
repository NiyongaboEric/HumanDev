part of 'journal_bloc.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class GetAllJournalEvent extends JournalEvent {
  const GetAllJournalEvent();
}

class AddNewReceivedMoneyJournalEvent extends JournalEvent {
  final List<ReceivedMoneyJournalRequest> journalRequests;

  const AddNewReceivedMoneyJournalEvent(this.journalRequests);
}

class UpdateReceivedJournalEvent extends JournalEvent {
  final ReceivedMoneyJournalRequest journalRequest;

  const UpdateReceivedJournalEvent(this.journalRequest);
}

class AddNewPaidMoneyJournalEvent extends JournalEvent {
  final List<PaidMoneyJournalRequest> journalRequests;

  const AddNewPaidMoneyJournalEvent(this.journalRequests);
}

class UpdatePaidMoneyJournalEvent extends JournalEvent {
  final PaidMoneyJournalRequest journalRequest;

  const UpdatePaidMoneyJournalEvent(this.journalRequest);
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