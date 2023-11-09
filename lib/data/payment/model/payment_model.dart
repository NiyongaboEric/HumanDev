import 'package:image_picker/image_picker.dart';

class PaymentModel {
  final int? id;
  final int? spaceId;
  final int? creditAccountId;
  final int? debitAccountId;
  final int? amount;
  final List<XFile>? images;
  final String? currency;
  final String? description;
  final int? accountantId;
  final int? recipientId;
  final String? recipientFirstName;
  final String? recipientLastName;
  final String? recipientRole;
  final String? companyName;
  final String? supplier;
  final List<String>? tags;
  final DateTime? createdAt;
  final String? updatedAt;

  const PaymentModel({
    this.id,
    this.spaceId,
    this.creditAccountId,
    this.debitAccountId,
    this.amount,
    this.images,
    this.currency,
    this.description,
    this.accountantId,
    this.recipientId,
    this.recipientFirstName,
    this.recipientLastName,
    this.recipientRole,
    this.companyName,
    this.supplier,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      spaceId: json['spaceId'],
      creditAccountId: json['creditAccountId'],
      debitAccountId: json['debitAccountId'],
      amount: json['amount'],
      images: json['images'],
      currency: json['currency'],
      description: json['description'],
      accountantId: json['accountantId'],
      recipientId: json['recipientId'],
      recipientFirstName: json['recipientFirstName'],
      recipientLastName: json['recipientLastName'],
      recipientRole: json['recipientRole'],
      companyName: json['companyName'],
      supplier: json['supplier'],
      tags: json['tags'].cast<String>(),
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
      'images': images,
      'currency': currency,
      'description': description,
      'accountantId': accountantId,
      'recipientId': recipientId,
      'recipientFirstName': recipientFirstName,
      'recipientLastName': recipientLastName,
      'recipientRole': recipientRole,
      'companyName': companyName,
      'supplier': supplier,
      'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
