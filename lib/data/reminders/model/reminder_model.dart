const reminderModel = {
  "id": 0,
  "type": "LOGGED_SMS",
  "organizerUserId": 0,
  "attendeePersonId": 0,
  "note": "string",
  "spaceId": 0,
  "createdAt": "2023-10-26T17:19:21.601Z",
  "updatedAt": "2023-10-26T17:19:21.601Z"
};

class ReminderModel {
  final int? id;
  final String? type;
  final int? organizerUserId;
  final int? attendeePersonId;
  final String? note;
  final int? spaceId;
  final String? createdAt;
  final String? updatedAt;

  ReminderModel({
    this.id,
    this.type,
    this.organizerUserId,
    this.attendeePersonId,
    this.note,
    this.spaceId,
    this.createdAt,
    this.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      type: json['type'],
      organizerUserId: json['organizerUserId'],
      attendeePersonId: json['attendeePersonId'],
      note: json['note'],
      spaceId: json['spaceId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson (){
    return {
      'id': id,
      'type': type,
      'organizerUserId': organizerUserId,
      'attendeePersonId': attendeePersonId,
      'note': note,
      'spaceId': spaceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}