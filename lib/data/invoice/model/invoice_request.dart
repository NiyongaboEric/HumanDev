var schema = {
  "totalAmount": 100,
  "invoiceDate": "2023-11-07",
  "currency": "GHS",
  "invoiceePersonId": 1,
  "studentPersonId": 2,
  "transactionIds": [1, 2],
  "paymentSchedules": [
    {"dueDate": "2023-12-07", "dueAmount": 100}
  ],
  "invoiceItems": [
    {"quantity": 2, "description": "Wooden desk", "price": 50, "total": 100}
  ],
  "isDraft": true
};

class InvoiceRequest {
  final int totalAmount;
  final String invoiceDate;
  final String currency;
  final int invoiceePersonId;
  final int studentPersonId;
  final List<int> transactionIds;
  final List<PaymentScheduleRequest> paymentSchedules;
  final List<InvoiceItemRequest> invoiceItems;
  final bool isDraft;

  InvoiceRequest({
    required this.totalAmount,
    required this.invoiceDate,
    required this.currency,
    required this.invoiceePersonId,
    required this.studentPersonId,
    required this.transactionIds,
    required this.paymentSchedules,
    required this.invoiceItems,
    required this.isDraft,
  });

  Map<String, dynamic> toJson() {
    return {
      "totalAmount": totalAmount,
      "invoiceDate": invoiceDate,
      "currency": currency,
      "invoiceePersonId": invoiceePersonId,
      "studentPersonId": studentPersonId,
      "transactionIds": transactionIds,
      "paymentSchedules": paymentSchedules.map((e) => e.toJson()).toList(),
      "invoiceItems": invoiceItems.map((e) => e.toJson()).toList(),
      "isDraft": isDraft,
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
      "dueAmount": dueAmount,
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
