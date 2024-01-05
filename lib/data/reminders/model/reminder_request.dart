import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';

enum ReminderType { LETTER, SENT_SMS, CALL, F2F, OTHER }

class ReminderRequest {
  final ReminderType type;
  final String? fullName;
  final String? phoneNumber;
  final String? note;
  final String? message;
  final String? scheduledTime;
  final List<DefaultTagsSettings>? tags;
  final List<Map<String, String>>? recipientsNameWithNumbers;
  final int? studentPersonId;
  final int? relativePersonId;
  final int? personId;

  const ReminderRequest({
    required this.type,
    this.fullName,
    this.phoneNumber,
    this.note,
    this.message,
    this.scheduledTime,
    this.tags,
    this.recipientsNameWithNumbers,
    this.studentPersonId,
    this.relativePersonId,
    this.personId,
  });

  Map<String, dynamic> toJson() {
    if (type == ReminderType.SENT_SMS) {
      return {
        'type': reminderEnumToString(type),
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'message': message,
        'scheduledTime': scheduledTime,
        'tags': tags,
        'studentPersonId': studentPersonId,
        'relativePersonId': relativePersonId,
      };
    }

    if (type == ReminderType.LETTER || type == ReminderType.F2F) {
      return {      'type': reminderEnumToString(type),
      'note': note,
      'tags': tags,
      'personId': personId,
      };      
    }

    return {
      'type': reminderEnumToString(type),
      'note': note,
      'tags': tags,
      'recipientsNameWithNumbers': recipientsNameWithNumbers,
      'personId': personId,
    };
  }

  factory ReminderRequest.fromJson(Map<String, dynamic> json) {
    return ReminderRequest(
      type: reminderStringToEnum(json['type']),
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      note: json['note'],
      message: json['message'],
      scheduledTime: json['scheduledTime'],
      tags: json['tags'],
      recipientsNameWithNumbers: json['recipientsNameWithNumbers'],
      studentPersonId: json['studentPersonId'],
      relativePersonId: json['relativePersonId'],
      personId: json['personId'],
    );
  }
}

String reminderEnumToString(ReminderType type) {
  switch (type) {
    case ReminderType.LETTER:
      return "LETTER";
    case ReminderType.SENT_SMS:
      return "SENT_SMS";
    case ReminderType.CALL:
      return "CALL";
    case ReminderType.F2F:
      return "F2F";
    case ReminderType.OTHER:
      return "OTHER";
  }
}

ReminderType reminderStringToEnum(String type) {
  switch (type) {
    case "LETTER":
      return ReminderType.LETTER;
    case "SENT_SMS":
      return ReminderType.SENT_SMS;
    case "CALL":
      return ReminderType.CALL;
    case "F2F":
      return ReminderType.F2F;
    case "OTHER":
      return ReminderType.OTHER;
    default:
      return ReminderType.SENT_SMS;
  }
}
