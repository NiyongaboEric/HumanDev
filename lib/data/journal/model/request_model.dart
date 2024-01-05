import 'package:seymo_pay_mobile_application/data/tags/model/tag_model.dart';

enum PaymentType { RECEIVED_MONEY, PAID_MONEY, OTHER }

class ReceivedMoneyJournalRequest {
  final int creditAccountId;
  final int debitAccountId;
  final String currency;
  final int amount;
  final int subaccountPersonId;
  final String? reason;
  final List<TagModel>? tags;
  final int studentPersonId;
  final int? invoiceId;
  final bool? isInvoicePayment;
  final bool? sendSMS;

  const ReceivedMoneyJournalRequest({
    required this.creditAccountId,
    required this.debitAccountId,
    required this.amount,
    required this.currency,
    this.reason,
    this.tags,
    this.sendSMS,
    required this.subaccountPersonId,
    required this.studentPersonId,
    this.invoiceId,
    this.isInvoicePayment,
  });

  Map<String, dynamic> toJson() {
    return {
      'creditAccountId': creditAccountId,
      'debitAccountId': debitAccountId,
      'amount': amount,
      'currency': currency,
      'reason': reason,
      'subaccountPersonId': subaccountPersonId,
      'studentPersonId': studentPersonId,
      'invoiceId': invoiceId,
      'isInvoicePayment': isInvoicePayment,
      'tags': tags,
      'sendSMS': sendSMS
    };
  }
}

class PaidMoneyJournalRequest {
  final int creditAccountId;
  final int debitAccountId;
  final int amount;
  final String currency;
  final int subaccountPersonId;
  final String? reason;
  final List<TagModel>? tags;

  const PaidMoneyJournalRequest({
    required this.creditAccountId,
    required this.debitAccountId,
    required this.amount,
    required this.currency,
    this.reason,
    this.tags,
    required this.subaccountPersonId,
  });

  Map<String, dynamic> toJson() {
    return {
      'creditAccountId': creditAccountId,
      'debitAccountId': debitAccountId,
      'amount': amount,
      'currency': currency,      
      'reason': reason,
      'subaccountPersonId': subaccountPersonId,
      'tags': tags,
    };
  }
}
