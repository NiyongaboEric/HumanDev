class RecipientModel {
  int? id;
  String? firstName;
  String? lastName;
  String? companyName;
  String? role;
  String? supplier;
  bool isPerson;

  RecipientModel({
    this.id,
    this.firstName,
    this.lastName,
    this.companyName,
    this.role,
    this.supplier,
    required this.isPerson,
  });

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    return RecipientModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      companyName: json['companyName'],
      role: json['role'],
      supplier: json['supplier'],
      isPerson: json['isPerson'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'companyName': companyName,
        'role': role,
        'supplier': supplier,
        'isPerson': isPerson,
      };
}
