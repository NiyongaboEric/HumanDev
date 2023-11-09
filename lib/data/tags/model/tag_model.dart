var schema = {
  "id": 3423,
  "name": "Financial situation of parents",
  "isReminderTag": true,
  "isMetricsTag": false,
  "isReceivedMoneyTag": false,
  "isPaidMoneyTag": false,
  "isSystem": false,
  "spaceId": 47,
  "createdAt": "2023-11-07T09:30:37.870Z",
  "updatedAt": "2023-11-07T09:30:37.870Z"
};

class TagModel {
  final int? id;
  final String? name;
  final bool? isReminderTag;
  final bool? isMetricsTag;
  final bool? isReceivedMoneyTag;
  final bool? isPaidMoneyTag;
  final bool? isSystem;
  final int? spaceId;
  final String? createdAt;
  final String? updatedAt;

  const TagModel({
    this.id,
    this.name,
    this.isReminderTag,
    this.isMetricsTag,
    this.isReceivedMoneyTag,
    this.isPaidMoneyTag,
    this.isSystem,
    this.spaceId,
    this.createdAt,
    this.updatedAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      name: json['name'],
      isReminderTag: json['isReminderTag'],
      isMetricsTag: json['isMetricsTag'],
      isReceivedMoneyTag: json['isReceivedMoneyTag'],
      isPaidMoneyTag: json['isPaidMoneyTag'],
      isSystem: json['isSystem'],
      spaceId: json['spaceId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class TagRequest {
  final String name;

  const TagRequest({required this.name});

  factory TagRequest.fromJson(Map<String, dynamic> json) {
    return TagRequest(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
