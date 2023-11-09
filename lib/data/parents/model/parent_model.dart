// Parent Model

class Parent {
  final String? id;
  final String? name;
  final String? phoneNumber;
  final String? childName;

  const Parent({
    this.id,
    this.name,
    this.phoneNumber,
    this.childName,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      childName: json['childName'],
    );
  }
}
