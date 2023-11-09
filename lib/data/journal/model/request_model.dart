import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';

enum PaymentType { RECEIVED_MONEY, PAID_MONEY, OTHER }

class JournalRequest {
  final int creditAccountId;
  final int debitAccountId;
  final int amount;
  final String? reason;
  final PaymentType paymentType;
  final List<int> personIds;
  final List<Tags>? tags;
  final bool? sendSMS;

  const JournalRequest({
    required this.creditAccountId,
    required this.debitAccountId,
    required this.amount,
    this.reason,
    required this.paymentType,
    required this.personIds,
    this.tags,
    this.sendSMS,
  });

  Map<String, dynamic> toJson() {
    return {
      'creditAccountId': creditAccountId,
      'debitAccountId': debitAccountId,
      'amount': amount,
      'reason': reason,
      'paymentType': paymentType.name,
      'personIds': personIds,
      'tags': tags,
      'sendSMS': sendSMS
    };
  }
}
