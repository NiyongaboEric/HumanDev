class GroupRequest {
  final String name;

  GroupRequest({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
