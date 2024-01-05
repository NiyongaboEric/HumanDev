var updateschema = {
  "totalAmount": 100,
  "invoiceDate": "2023-11-07",
  "currency": "GHS",
  "invoiceePersonId": 1,
  "studentPersonId": 2,
  "paymentSchedules": {
    "createOrUpdate": [
      {"id": 1, "dueDate": "2023-12-07", "dueAmount": 100}
    ],
    "deleteIds": [0]
  },
  "invoiceItems": [
    {"quantity": 2, "description": "Wooden desk", "price": 50, "total": 100}
  ],
  "transactionIds": [1, 2],
  "isDraft": true
};

class InvoiceCreateRequest {
  final int totalAmount;
  final String invoiceDate;
  final String currency;
  final int invoiceePersonId;
  final int? studentPersonId;
  final List<int>? transactionIds;
  final List<PaymentScheduleRequest> paymentSchedules;
  final List<InvoiceItemRequest> invoiceItems;
  final bool isDraft;
  final String? type;
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
  final int price;
  final int total;

  InvoiceItemRequest({
    required this.quantity,
    required this.description,
    required this.price,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "description": description,
      "price": price,
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
