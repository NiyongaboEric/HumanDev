class Space {
  final int? id;
  final String? name;
  final String? createdAt; // Change the type to String
  final String? updatedAt; // Change the type to String

  const Space({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'],
      name: json['name'],
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
