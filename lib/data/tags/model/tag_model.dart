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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isReminderTag': isReminderTag,
      'isMetricsTag': isMetricsTag,
      'isReceivedMoneyTag': isReceivedMoneyTag,
      'isPaidMoneyTag': isPaidMoneyTag,
      'isSystem': isSystem,
      'spaceId': spaceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
