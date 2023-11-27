import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';

class PersonRequest {
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final Role? role;
  final String? phoneNumber;
  final bool isLegal;
  final String? counterpartyName;

  const PersonRequest({
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.role,
    this.phoneNumber,
    required this.isLegal,
    this.counterpartyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      'role': role?.name,
      'phoneNumber': phoneNumber,
      'isLegal': isLegal,
      'counterpartyName': counterpartyName,
    };
  }
}
