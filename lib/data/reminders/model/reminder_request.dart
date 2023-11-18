
class ReminderRequest {
  final String type;
  final String? note;
  final String? message;
  final String? scheduledTime;
  final List<Tags>? tags;
  final List<int> attendeePersonIds;
  final bool expandRelations;

  const ReminderRequest({
    required this.type,
    this.note,
    this.message,
    this.scheduledTime,
    this.tags,
    required this.attendeePersonIds,
    required this.expandRelations,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'note': note,
      'message': message,
      'scheduledTime': scheduledTime,
      'tags': tags,
      'attendeePersonIds': attendeePersonIds,
      'expandRelations': expandRelations,
    };
  }

  factory ReminderRequest.fromJson(Map<String, dynamic> json) {
    return ReminderRequest(
      type: json['type'],
      note: json['note'],
      message: json['message'],
      scheduledTime: json['scheduledTime'],
      tags: json['tags'],
      attendeePersonIds: json['attendeePersonIds'],
      expandRelations: json['expandRelations'],
    );
  }
}

class Tags {
  final String name;

  Tags({required this.name});

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
