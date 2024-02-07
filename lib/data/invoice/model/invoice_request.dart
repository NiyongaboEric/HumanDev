
class InvoiceCreateRequest {
  final int totalAmount;
  final String invoiceDate;
  final String currency;
  final int invoiceePersonId;
  final int? studentPersonId;
  final List<int>? transactionIds;
  final List<PaymentScheduleRequest> paymentSchedules;
  final List<InvoiceItemRequest> invoiceItems;
  bool isDraft;
  final String? type;
  final int? grossPrice;
  final int? netPrice;
  final int taxAmount;
  final double? taxRate;
  final int? creditNoteForInvoiceId;

  InvoiceCreateRequest({
    required this.totalAmount,
    required this.invoiceDate,
    required this.currency,
    required this.invoiceePersonId,
    this.studentPersonId,
    this.transactionIds,
    required this.paymentSchedules,
    required this.invoiceItems,
    required this.isDraft,
    this.grossPrice,
    this.netPrice,
    required this.taxAmount,
    this.taxRate,
    this.type,
    this.creditNoteForInvoiceId,
  });

  Map<String, dynamic> toJson() {
    if (transactionIds == null) {
      return {
        "totalAmount": totalAmount,
        "invoiceDate": invoiceDate,
        "currency": currency,
        "invoiceePersonId": invoiceePersonId,
        "studentPersonId": studentPersonId,
        "paymentSchedules": paymentSchedules.map((e) => e.toJson()).toList(),
        "invoiceItems": invoiceItems.map((e) => e.toJson()).toList(),
        "isDraft": isDraft,
        "type": type,
        // "price_gross": grossPrice ?? 0,
        // "price_net": netPrice ?? 0,
        // "tax_amount": taxAmount,
        // "tax_rate": taxRate,
        "creditNoteForInvoiceId": creditNoteForInvoiceId,
      };
    } else {
      return {
        "totalAmount": totalAmount,
        "invoiceDate": invoiceDate,
        "currency": currency,
        "invoiceePersonId": invoiceePersonId,
        "studentPersonId": studentPersonId,
        "paymentSchedules": paymentSchedules.map((e) => e.toJson()).toList(),
        "invoiceItems": invoiceItems.map((e) => e.toJson()).toList(),
        "isDraft": isDraft,
        "type": type,
        // "price_gross": grossPrice,
        // "price_net": netPrice,
        // "tax_amount": taxAmount,
        // "tax_rate": taxRate,
        "creditNoteForInvoiceId": creditNoteForInvoiceId,
      };
    }
  }
}

class InvoiceUpdateRequest {
  final int totalAmount;
  final String invoiceDate;
  final String currency;
  final int invoiceePersonId;
  final int? studentPersonId;
  final List<int>? transactionIds;
  final List<PaymentScheduleRequest> paymentSchedules;
  final List<InvoiceItemRequest> invoiceItems;
  final bool isDraft;
  final int? grossPrice;
  final int? netPrice;
  final int taxAmount;
  final double? taxRate;
  final String? type;
  final int? creditNoteForInvoiceId;

  InvoiceUpdateRequest({
    required this.totalAmount,
    required this.invoiceDate,
    required this.currency,
    required this.invoiceePersonId,
    this.studentPersonId,
    this.transactionIds,
    required this.paymentSchedules,
    required this.invoiceItems,
    required this.isDraft,
    this.grossPrice,
    this.netPrice,
    required this.taxAmount,
    this.taxRate,
    this.type,
    this.creditNoteForInvoiceId,
  });

  Map<String, dynamic> toJson() {
    if (transactionIds == null) {
      return {
        "totalAmount": totalAmount,
        "invoiceDate": invoiceDate,
        "currency": currency,
        "invoiceePersonId": invoiceePersonId,
        "studentPersonId": studentPersonId,
        "paymentSchedules": paymentSchedules.map((e) => e.toJson()).toList(),
        "invoiceItems": invoiceItems.map((e) => e.toJson()).toList(),
        "isDraft": isDraft,
        "price_gross": grossPrice ?? 0,
        "price_net": netPrice ?? 0,
        "tax_amount": taxAmount,
        "tax_rate": taxRate,
        "type": type,
        "creditNoteForInvoiceId": creditNoteForInvoiceId,
      };
    } else {
      return {
        "totalAmount": totalAmount,
        "invoiceDate": invoiceDate,
        "currency": currency,
        "invoiceePersonId": invoiceePersonId,
        "studentPersonId": studentPersonId,
        "paymentSchedules": paymentSchedules.map((e) => e.toJson()).toList(),
        "invoiceItems": invoiceItems.map((e) => e.toJson()).toList(),
        "isDraft": isDraft,
        "price_gross": grossPrice ?? 0,
        "price_net": netPrice ?? 0,
        "tax_amount": taxAmount,
        "tax_rate": taxRate,
        "type": type,
        "creditNoteForInvoiceId": creditNoteForInvoiceId,
      };
    }
  }
}

class EditPaymentScheduleRequest {
  final List<PaymentScheduleRequest> createOrUpdate;
  final List<int> deleteIds;

  EditPaymentScheduleRequest({
    required this.createOrUpdate,
    required this.deleteIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "createOrUpdate": createOrUpdate.map((e) => e.toJson()).toList(),
      "deleteIds": deleteIds,
    };
  }
}

class PaymentScheduleRequest {
  final String dueDate;
  final int dueAmount;

  PaymentScheduleRequest({
    required this.dueDate,
    required this.dueAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      "dueDate": dueDate,
      "totalDueAmount": dueAmount,
    };
  }
}

class InvoiceItemRequest {
  final int quantity;
  final String description;
  final int? grossPrice;
  final int? netPrice;
  final int? taxAmount;
  final double? taxRate;
  final int total;

  InvoiceItemRequest({
    required this.quantity,
    required this.description,
    this.grossPrice,
    this.netPrice,
    this.taxAmount,
    this.taxRate,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "description": description,
      "price_gross": grossPrice,
      "price_net": netPrice ?? 0,
      "tax_rate": taxRate,
      "tax_amount": taxAmount ?? 0,
      "total": total,
    };
  }
}

class InvoiceResponse {
  final bool? isSuccess;
  final String? message;
  final String? errorMessage;

  InvoiceResponse({
    required this.isSuccess,
    this.message,
    this.errorMessage,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isSuccess": isSuccess,
      "message": message,
      "errorMessage": errorMessage,
    };
  }
}
