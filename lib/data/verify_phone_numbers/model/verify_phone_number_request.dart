class VerifyPhoneNumberRequest {
  final String phoneNumber;
  final String verificationCode;

  VerifyPhoneNumberRequest({
    required this.phoneNumber,
    required this.verificationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'verificationCode': verificationCode,
    };
  }
}
