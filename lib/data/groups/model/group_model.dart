class Group {
  final int? id;
  final String? name;
  final bool? isRole;
  final bool? isActive;
  final int? spaceId;

  const Group({
    this.id,
    this.name,
    this.isRole,
    this.isActive,
    this.spaceId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      isRole: json['isRole'],
      isActive: json['isActive'],
      spaceId: json['spaceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isRole': isRole,
      'isActive': isActive,
      'spaceId': spaceId,
    };
  }
}