part of 'paid_money_bloc.dart';

sealed class PaidMoneyEvent extends Equatable {
  const PaidMoneyEvent();

  @override
  List<Object> get props => [];
}

class GetAllPaidMoneyEvent extends PaidMoneyEvent {
  const GetAllPaidMoneyEvent();
}

class AddNewPaidMoneyEvent extends PaidMoneyEvent {
  final PaymentRequest paymentRequest;

  const AddNewPaidMoneyEvent(this.paymentRequest);
}

class UpdatePaidMoneyEvent extends PaidMoneyEvent {
  final PaymentRequest paymentRequest;

  const UpdatePaidMoneyEvent(this.paymentRequest);
}

class DeletePaidMoneyEvent extends PaidMoneyEvent {
  final String paymentID;

  const DeletePaidMoneyEvent(this.paymentID);
}

class SaveDataPaidMoneyState extends PaidMoneyEvent {
  final PaymentModel paymentRequest;

  const SaveDataPaidMoneyState(this.paymentRequest);
}

class ClearDataPaidMoneyState extends PaidMoneyEvent {
  const ClearDataPaidMoneyState();
}
