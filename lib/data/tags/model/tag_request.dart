class TagRequest {
  final String name;

  TagRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  factory TagRequest.fromJson(Map<String, dynamic> json) {
    return TagRequest(name: json['name']);
  }
}
