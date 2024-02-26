import 'package:seymo_pay_mobile_application/data/constants/logger.dart';

class Space {
  final int? id;
  final String? name;
  final SpaceSettings? spaceSettings;
  final String? currency;
  final String? timezone;
  final String? country;
  final String? language;
  final int? lastInvoiceNumber;
  final int? lastCreditNoteNumber; // Add lastCreditNoteNumber field
  final bool? sendViaAws;
  final String? createdAt; // Change the type to String
  final String? updatedAt; // Change the type to String
  final LegalEntityPerson? legalEntityPerson; // Include legalEntityPerson field

  const Space({
    this.id,
    this.name,
    this.spaceSettings,
    this.language,
    this.country,
    this.timezone,
    this.lastInvoiceNumber,
    this.lastCreditNoteNumber,
    this.sendViaAws,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.legalEntityPerson,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    // logger.f(json['currency']);
    return Space(
      id: json['id'],
      name: json['name'],
      spaceSettings: json['spaceSettings'] != null
          ? SpaceSettings.fromJson(json['spaceSettings'])
          : null,
      language: json['language'] ?? 'en',
      country: json['country'],
      timezone: json['timezone'] ?? '',
      lastInvoiceNumber: json['lastInvoiceNumber'] ?? 0,
      lastCreditNoteNumber: json['lastCreditNoteNumber'] ?? 0,
      sendViaAws: json['sendViaAws'] ?? false,
      currency: json['currency'],
      createdAt: json['createdAt'], // Keep it as String
      updatedAt: json['updatedAt'], // Keep it as String
      legalEntityPerson: json['legalEntityPerson'] != null
          ? LegalEntityPerson.fromJson(json['legalEntityPerson'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'spaceSettings': spaceSettings?.toJson(),
      'language': language,
      'country': country,
      'timezone': timezone,
      'lastInvoiceNumber': lastInvoiceNumber,
      'lastCreditNoteNumber': lastCreditNoteNumber,
      'sendViaAws': sendViaAws,
      'currency': currency,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SpaceSettings {
  SmsTemplates smsTemplates;

  SpaceSettings({required this.smsTemplates});

  factory SpaceSettings.fromJson(Map<String, dynamic> json) {
    return SpaceSettings(
      smsTemplates: SmsTemplates.fromJson(json['smsTemplates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'smsTemplates': smsTemplates.toJson(),
    };
  }
}

class SmsTemplates {
  SmsTemplate en;

  SmsTemplates({required this.en});

  factory SmsTemplates.fromJson(Map<String, dynamic> json) {
    return SmsTemplates(
      en: SmsTemplate.fromJson(json['en']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en.toJson(),
    };
  }
}

class SmsTemplate {
  String reminder;
  String paidMoney;
  String receivedMoney;
  String receivedMoneyParty;

  SmsTemplate({
    required this.reminder,
    required this.paidMoney,
    required this.receivedMoney,
    required this.receivedMoneyParty,
  });

  factory SmsTemplate.fromJson(Map<String, dynamic> json) {
    return SmsTemplate(
      reminder: json['reminder'],
      paidMoney: json['paidMoney'],
      receivedMoney: json['receivedMoney'],
      receivedMoneyParty: json['receivedMoneyParty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminder': reminder,
      'paidMoney': paidMoney,
      'receivedMoney': receivedMoney,
      'receivedMoneyParty': receivedMoneyParty,
    };
  }
}

class LegalEntityPerson {
  int? id;
  String? userId;
  String? firstName;
  String? middleName;
  String? lastName1;
  String? lastName2;
  String? dateOfBirth;
  String? phoneNumber1;
  String? phoneNumber2;
  String? phoneNumber3;
  String? email1;
  String? email2;
  String? email3;
  String? taxId;
  String? VATId;
  String? gender;
  Map<String, dynamic>? address;
  int? spaceId;
  Map<String, dynamic>? tagsSettings;
  Map<String, dynamic>? personSettings;
  bool? isLegal;
  String? organizationName;
  String? notes;
  String? createdAt;
  String? updatedAt;
  bool? isDeactivated;
  String? deactivationDate;
  String? personDeactivatedById;
  int? legalEntitySpaceId;

  LegalEntityPerson({
    this.id,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.email1,
    this.email2,
    this.email3,
    this.taxId,
    this.VATId,
    this.gender,
    this.address,
    this.spaceId,
    this.tagsSettings,
    this.personSettings,
    this.isLegal,
    this.organizationName,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.isDeactivated,
    this.deactivationDate,
    this.personDeactivatedById,
    this.legalEntitySpaceId,
  });

  factory LegalEntityPerson.fromJson(Map<String, dynamic> json) {
    return LegalEntityPerson(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName1: json['lastName1'],
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      phoneNumber1: json['phoneNumber1'],
      phoneNumber2: json['phoneNumber2'],
      phoneNumber3: json['phoneNumber3'],
      email1: json['email1'],
      email2: json['email2'],
      email3: json['email3'],
      taxId: json['taxId'],
      VATId: json['VATId'],
      gender: json['gender'],
      address: json['address'],
      spaceId: json['spaceId'],
      tagsSettings: json['tagsSettings'],
      personSettings: json['personSettings'],
      isLegal: json['isLegal'],
      organizationName: json['organizationName'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isDeactivated: json['isDeactivated'],
      deactivationDate: json['deactivationDate'],
      personDeactivatedById: json['personDeactivatedById'],
      legalEntitySpaceId: json['legalEntitySpaceId'],
    );
  }
}
