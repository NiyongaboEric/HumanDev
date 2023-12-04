import 'package:seymo_pay_mobile_application/data/tags/model/tag_model.dart';

const schema = {
  "type": "LETTER",
  "note": "Note for this reminder. Text...",
  "message": "Message...",
  "scheduledTime": "2023-12-03T11:40:16.134Z",
  "tags": [
    {"id": 0, "name": "string"}
  ],
  "studentPersonId": 0,
  "relativePersonId": 0,
  "personId": 0
};

enum ReminderType { LETTER, SENT_SMS, CALL, F2F, OTHER }

class ReminderRequest {
  final ReminderType type;
  final String? note;
  final String? message;
  final String? scheduledTime;
  final List<TagModel>? tags;
  final int? studentPersonId;
  final int? relativePersonId;
  final int? personId;

  const ReminderRequest({
    required this.type,
    this.note,
    this.message,
    this.scheduledTime,
    this.tags,
    this.studentPersonId,
    this.relativePersonId,
    this.personId,
  });

  Map<String, dynamic> toJson() {
    if (type == ReminderType.SENT_SMS) {
      return {
        'type': reminderEnumToString(type),
        'message': message,
        'scheduledTime': scheduledTime,
        'tags': tags,
        'studentPersonId': studentPersonId,
        'relativePersonId': relativePersonId,
      };
    }
    return {
      'type': reminderEnumToString(type),
      'note': note,
      'tags': tags,
      'personId': personId,
    };
  }

  factory ReminderRequest.fromJson(Map<String, dynamic> json) {
    return ReminderRequest(
      type: reminderStringToEnum(json['type']),
      note: json['note'],
      message: json['message'],
      scheduledTime: json['scheduledTime'],
      tags: json['tags'],
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
