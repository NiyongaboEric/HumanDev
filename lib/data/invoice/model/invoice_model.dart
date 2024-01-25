

class InvoiceModel {
  final int id;
  final int spaceId;
  final String? number;
  final int totalAmount;
  final String invoiceDate;
  final int creatorPersonId;
  final int invoiceePersonId;
  final int studentPersonId;
  final String type;
  final String currency;
  final bool isPaid;
  final bool isVoid;
  final bool isDraft;
  final String createdAt;
  final String updatedAt;
  final List<PaymentScheduleModel>? paymentSchedules;
  final List<InvoiceItemModel>? invoiceItems;

  InvoiceModel({
    required this.id,
    required this.spaceId,
    this.number,
    required this.totalAmount,
    required this.invoiceDate,
    required this.creatorPersonId,
    required this.invoiceePersonId,
    required this.studentPersonId,
    required this.type,
    required this.currency,
    required this.isPaid,
    required this.isVoid,
    required this.isDraft,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentSchedules,
    required this.invoiceItems,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      spaceId: json['spaceId'],
      number: json['number'],
      totalAmount: json['totalAmount'],
      invoiceDate: json['invoiceDate'],
      creatorPersonId: json['creatorPersonId'],
      invoiceePersonId: json['invoiceePersonId'],
      studentPersonId: json['studentPersonId'],
      type: json['type'],
      currency: json['currency'],
      isPaid: json['isPaid'],
      isVoid: json['isVoid'],
      isDraft: json['isDraft'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      paymentSchedules: json['paymentSchedules'] == null
          ? null
          : (json['paymentSchedules'] as List)
              .map<PaymentScheduleModel>(
                  (e) => PaymentScheduleModel.fromJson(e))
              .toList(),
      invoiceItems: json['invoiceItems'] == null
          ? null
          : (json['invoiceItems'] as List)
              .map<InvoiceItemModel>((e) => InvoiceItemModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalAmount": totalAmount,
      "invoiceDate": invoiceDate,
      "currency": currency,
      "invoiceePersonId": invoiceePersonId,
      "studentPersonId": studentPersonId,
      "paymentSchedules": paymentSchedules == null
          ? null
          : paymentSchedules!.map((e) => e.toJson()).toList(),
      "invoiceItems": invoiceItems == null
          ? null
          : invoiceItems!.map((e) => e.toJson()).toList(),
      "isDraft": isDraft,
    };
  } 
}

class PaymentScheduleModel {
  final int? id;
  final int? spaceId;
  final int? sequenceNumber;
  final String? dueDate;
  final int? dueAmount;
  final int? totalDueAmount;
  final String? lastPaidDate;
  final int? paidAmount;
  final int? invoiceId;
  final String? createdAt;
  final String? updatedAt;

  PaymentScheduleModel({
    this.id,
    this.spaceId,
    this.sequenceNumber,
    this.dueDate,
    this.dueAmount,
    this.totalDueAmount,
    this.lastPaidDate,
    this.paidAmount,
    this.invoiceId,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentScheduleModel.fromJson(Map<String, dynamic> json) {
    return PaymentScheduleModel(
      id: json['id'],
      spaceId: json['spaceId'],
      sequenceNumber: json['sequenceNumber'],
      dueDate: json['dueDate'],
      dueAmount: json['dueAmount'],
      totalDueAmount: json['totalDueAmount'],
      lastPaidDate: json['lastPaidDate'],
      paidAmount: json['paidAmount'],
      invoiceId: json['invoiceId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "spaceId": spaceId,
      "sequenceNumber": sequenceNumber,
      "dueDate": dueDate,
      "dueAmount": dueAmount,
      "totalDueAmount": totalDueAmount,
      "lastPaidDate": lastPaidDate,
      "paidAmount": paidAmount,
      "invoiceId": invoiceId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }  
}

class InvoiceItemModel {
  final int? id;
  final int? spaceId;
  final int? quantity;
  final String? description;
  final int? price;
  final int? total;
  final int? invoiceId;
  final int? grossPrice;
  final int? netPrice;
  final String? createdAt;
  final String? updatedAt;

  InvoiceItemModel({
    this.id,
    this.spaceId,
    this.quantity,
    this.description,
    this.price,
    this.total,
    this.invoiceId,
    this.grossPrice,
    this.netPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'],
      spaceId: json['spaceId'],
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'],
      total: json['total'],
      invoiceId: json['invoiceId'],
      grossPrice: json['price_gross'],
      netPrice: json['price_net'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "spaceId": spaceId,
      "quantity": quantity,
      "description": description,
      "price": price,
      "total": total,
      "invoiceId": invoiceId,
      "price_gross": grossPrice,
      "price_net": netPrice,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
