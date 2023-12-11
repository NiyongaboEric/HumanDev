import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';

class PersonRequest {
  final int? id;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final Role? role;
  final String? phoneNumber;
  final bool isLegal;
  final String? organizationName;

  const PersonRequest({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.role,
    this.phoneNumber,
    required this.isLegal,
    this.organizationName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      'role': role?.name,
      'phoneNumber': phoneNumber,
      'isLegal': isLegal,
      'organizationName': organizationName,
    };
  }
}

class UpdatePersonRequest {
  final int? id;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final bool isLegal;
  final String? counterpartyName;
  final List<int>? connectGroupIds;
  final List<int>? disconnectGroupIds;
  final List<ConnectedPersonRelativeRelation>? connectPersonRelativeRelations;
  final List<int>? disconnectPersonRelativeRelations;
  final List<ConnectedPersonChildRelation>? connectPersonChildRelations;
  final List<int>? disconnectPersonChildRelations;
  final bool isDeactivated;

  const UpdatePersonRequest({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    required this.isLegal,
    this.counterpartyName,
    this.connectGroupIds,
    this.disconnectGroupIds,
    this.connectPersonRelativeRelations,
    this.disconnectPersonRelativeRelations,
    this.connectPersonChildRelations,
    this.disconnectPersonChildRelations,
    required this.isDeactivated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      'phoneNumber1': phoneNumber1,
      'phoneNumber2': phoneNumber2,
      'phoneNumber3': phoneNumber3,
      'isLegal': isLegal,
      'counterpartyName': counterpartyName,
      'connectGroupIds': connectGroupIds,
      'disconnectGroupIds': disconnectGroupIds,
      'connectPersonRelativeRelations': connectPersonRelativeRelations,
      'disconnectPersonRelativeRelations': disconnectPersonRelativeRelations,
      'connectPersonChildRelations': connectPersonChildRelations,
      'disconnectPersonChildRelations': disconnectPersonChildRelations,
      'isDeactivated': isDeactivated,
    };
  }
}

class ConnectedPersonRelativeRelation {
  final int? childPersonId;
  final String? relation;

  const ConnectedPersonRelativeRelation({
    this.childPersonId,
    this.relation,
  });

  Map<String, dynamic> toJson() {
    return {
      'childPersonId': childPersonId,
      'relation': relation,
    };
  }
}

class ConnectedPersonChildRelation {
  final int? relativePersonId;
  final String? relation;

  const ConnectedPersonChildRelation({
    this.relativePersonId,
    this.relation,
  });

  Map<String, dynamic> toJson() {
    return {
      'relativePersonId': relativePersonId,
      'relation': relation,
    };
  }
}