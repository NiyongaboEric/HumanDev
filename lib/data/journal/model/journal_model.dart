class JournalModel {
  final int? id;
  final int? spaceId;
  final int? creditAccountId;
  final int? debitAccountId;
  final int? amount;
  final String? currency;
  final String? reason;
  final String? description;
  final List<String>? tags;
  final int? recipientId;
  final String? recipientFirstName;
  final String? recipientLastName;
  final String? recipientRole;
  final String? companyName;
  final String? supplier;
  final int? accountantId;
  final int? personId;
  final String? createdAt;
  final String? updatedAt;

  const JournalModel({
    this.id,
    this.spaceId,
    this.creditAccountId,
    this.debitAccountId,
    this.amount,
    this.currency,
    this.reason,
    this.description,
    this.tags,
    this.recipientId,
    this.recipientFirstName,
    this.recipientLastName,
    this.recipientRole,
    this.companyName,
    this.supplier,
    this.accountantId,
    this.personId,
    this.createdAt,
    this.updatedAt,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      spaceId: json['spaceId'],
      creditAccountId: json['creditAccountId'],
      debitAccountId: json['debitAccountId'],
      amount: json['amount'],
      currency: json['currency'],
      reason: json['reason'],
      description: json['description'],
      tags: json['tags'] != null ? json['tags'].cast<String>() : null,
      recipientId: json['recipientId'],
      recipientFirstName: json['recipientFirstName'],
      recipientLastName: json['recipientLastName'],
      recipientRole: json['recipientRole'],
      companyName: json['companyName'],
      supplier: json['supplier'],
      accountantId: json['accountantId'],
      personId: json['personId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceId': spaceId,
      'creditAccountId': creditAccountId,
      'debitAccountId': debitAccountId,
      'amount': amount,
      'currency': currency,
      'reason': reason,
      'description': description,
      'tags': tags,
      'recipientId': recipientId,
      'recipientFirstName': recipientFirstName,
      'recipientLastName': recipientLastName,
      'recipientRole': recipientRole,
      'companyName': companyName,
      'supplier': supplier,
      'accountantId': accountantId,
      'personId': personId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
