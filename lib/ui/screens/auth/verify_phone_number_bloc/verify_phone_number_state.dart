part of 'verify_phone_number_bloc.dart';

enum VerifyPhoneNumberStatus {
  initial,
  verified,
  unverified,
  verifyPhoneNumberSuccess,
  verifyPhoneNumberFailure,
}

class VerifyPhoneNumberState {
  final VerifyPhoneNumberStatus status;
  final bool isLoading;

  final String? phoneNumber;
  final String? verificationCode;
  final String? verifyPhoneNumberMessage;
  final String? verifyPhoneNumberFailure;

  const VerifyPhoneNumberState({
    this.status = VerifyPhoneNumberStatus.initial,
    this.isLoading = false,
    this.phoneNumber,
    this.verificationCode,
    this.verifyPhoneNumberMessage,
    this.verifyPhoneNumberFailure
  });

  VerifyPhoneNumberState copyWith({
    VerifyPhoneNumberStatus? status,
    bool? isLoading,
    String? verificationCode,
    String? phoneNumber,
    String? verifyPhoneNumberMessage,
    String? verifyPhoneNumberFailure,
  }) {
    return VerifyPhoneNumberState(
      status: status ?? this.status, 
      isLoading: isLoading ?? this.isLoading,
      phoneNumber: phoneNumber ?? this.phoneNumber, 
      verificationCode: verificationCode ?? this.verificationCode,
      verifyPhoneNumberMessage: verifyPhoneNumberMessage ?? this.verifyPhoneNumberMessage,
      verifyPhoneNumberFailure: verifyPhoneNumberFailure ?? this.verifyPhoneNumberFailure
    );
  }
}
