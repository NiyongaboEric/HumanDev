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
  final bool? sendViaAws;
  final String? createdAt; // Change the type to String
  final String? updatedAt; // Change the type to String

  const Space({
    this.id,
    this.name,
    this.spaceSettings,
    this.language,
    this.country,
    this.timezone,
    this.lastInvoiceNumber,
    this.sendViaAws,
    this.currency,
    this.createdAt,
    this.updatedAt,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    logger.wtf("spaceSettings: ${json["spaceSettings"]}");
    // logger.wtf("spaceSettings: ${SpaceSettings.fromJson(json["spaceSettings"])}");
    return Space(
      id: json['id'],
      name: json['name'],
      spaceSettings: json['spaceSettings'] != null
          ? SpaceSettings.fromJson(json['spaceSettings'])
          : null,
      language: json['language'] ?? 'en',
      country: json['country'],
      timezone: json['timezone'],
      lastInvoiceNumber: json['lastInvoiceNumber'],
      sendViaAws: json['sendViaAws'],
      currency: json['currency'],
      createdAt: json['createdAt'], // Keep it as String
      updatedAt: json['updatedAt'], // Keep it as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
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
}

class SmsTemplates {
  SmsTemplate en;

  SmsTemplates({required this.en});

  factory SmsTemplates.fromJson(Map<String, dynamic> json) {
    return SmsTemplates(
      en: SmsTemplate.fromJson(json['en']),
    );
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
}
