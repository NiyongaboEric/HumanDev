class PaymentRequest {
  final int? id;
  final int creditAccountId;
  final int debitAccountId;
  final int amount;
  final String currency;
  final String reason;
  final List<int> personIds;
  final bool sendSMS;

  const PaymentRequest({
    this.id,
    required this.creditAccountId,
    required this.debitAccountId,
    required this.amount,
    required this.currency,
    required this.reason,
    required this.personIds,
    required this.sendSMS,
  });

  Map<String, dynamic> toJson() {
    if (id != null) {
      return {
        'id': id,
        'creditAccountId': creditAccountId,
        'debitAccountId': debitAccountId,
        'amount': amount,
        'currency': currency,
        'reason': reason,
        'personIds': personIds,
        'sendSMS': sendSMS,
      };
    } else {
      return {
        'creditAccountId': creditAccountId,
        'debitAccountId': debitAccountId,
        'amount': amount,
        'currency': currency,
        'reason': reason,
        'personIds': personIds,
        'sendSMS': sendSMS,
      };
    }
  }
}
