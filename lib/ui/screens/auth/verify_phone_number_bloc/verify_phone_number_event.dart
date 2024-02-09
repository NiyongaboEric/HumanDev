part of 'verify_phone_number_bloc.dart';

sealed class VerifyPhoneNumberEvent extends Equatable {
  const VerifyPhoneNumberEvent();

  @override
  List<Object> get props => [];
}

class ValidateVerifyPhoneNumberEvent extends VerifyPhoneNumberEvent {
  final VerifyPhoneNumberRequest verifyPhoneNumberRequest;

  const ValidateVerifyPhoneNumberEvent(this.verifyPhoneNumberRequest);
}
