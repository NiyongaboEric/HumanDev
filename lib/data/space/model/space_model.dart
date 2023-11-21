class Space {
  final int? id;
  final String? name;
  final SpaceSettings? spaceSettings;
  final String? currency;
  final String? createdAt; // Change the type to String
  final String? updatedAt; // Change the type to String

  const Space({
    this.id,
    this.name,
    this.spaceSettings,
    this.currency,
    this.createdAt,
    this.updatedAt,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'],
      name: json['name'],
      spaceSettings: json['spaceSettings'] != null
          ? SpaceSettings.fromJson(json['spaceSettings'])
          : null,
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
  final SMSTemplates? smsTemplates;

  const SpaceSettings({
    this.smsTemplates,
  });

  factory SpaceSettings.fromJson(Map<String, dynamic> json) {
    return SpaceSettings(
      smsTemplates: json['smsTemplates'] != null
          ? SMSTemplates.fromJson(json['smsTemplates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'smsTemplates': smsTemplates};
  }
}

class SMSTemplates {
  final EngSMSTemplates? en;

  const SMSTemplates({
    this.en,
  });

  factory SMSTemplates.fromJson(Map<String, dynamic> json) {
    return SMSTemplates(
      en: json['en'] != null ? EngSMSTemplates.fromJson(json['en']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'en': en};
  }
}

class EngSMSTemplates {
  final String? reminder;
  final String? paidMoney;
  final String? receivedMoney;

  const EngSMSTemplates({
    this.reminder,
    this.paidMoney,
    this.receivedMoney,
  });

  factory EngSMSTemplates.fromJson(Map<String, dynamic> json) {
    return EngSMSTemplates(
      reminder: json['reminder'],
      paidMoney: json['paidMoney'],
      receivedMoney: json['receivedMoney'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminder': reminder,
      'paidMoney': paidMoney,
      'receivedMoney': receivedMoney,
    };
  }
}
