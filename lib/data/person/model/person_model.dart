import '../../groups/model/group_model.dart';

var schema = {
  "id": 0,
  "userId": 0,
  "email1": "string",
  "email2": "string",
  "email3": "string",
  "tagsSettings": {},
  "personSettings": {},
  "VATId": "string",
  "taxId": "string",
  "firstName": "string",
  "middleName": "string",
  "lastName1": "string",
  "lastName2": "string",
  "dateOfBirth": "string",
  "spaceId": 0,
  "phoneNumber1": "string",
  "phoneNumber2": "string",
  "phoneNumber3": "string",
  "isActive": true,
  "isLegal": true,
  "organizationName": "string",
  "createdAt": "2023-11-25T04:44:37.891Z",
  "updatedAt": "2023-11-25T04:44:37.891Z",
  "isDeactivated": true,
  "deactivationDate": "2023-11-25T04:44:37.891Z",
  "personDeactivatedById": 0,
  "childRelations": [
    {
      "id": 0,
      "userId": 0,
      "email1": "string",
      "email2": "string",
      "email3": "string",
      "tagsSettings": {},
      "personSettings": {},
      "VATId": "string",
      "taxId": "string",
      "firstName": "string",
      "middleName": "string",
      "lastName1": "string",
      "lastName2": "string",
      "dateOfBirth": "string",
      "spaceId": 0,
      "phoneNumber1": "string",
      "phoneNumber2": "string",
      "phoneNumber3": "string",
      "isActive": true,
      "isLegal": true,
      "organizationName": "string",
      "createdAt": "2023-11-25T04:44:37.891Z",
      "updatedAt": "2023-11-25T04:44:37.891Z",
      "isDeactivated": true,
      "deactivationDate": "2023-11-25T04:44:37.891Z",
      "personDeactivatedById": 0,
      "relation": "PARENT"
    }
  ],
  "relativeRelations": [
    {
      "id": 0,
      "userId": 0,
      "email1": "string",
      "email2": "string",
      "email3": "string",
      "tagsSettings": {},
      "personSettings": {},
      "VATId": "string",
      "taxId": "string",
      "firstName": "string",
      "middleName": "string",
      "lastName1": "string",
      "lastName2": "string",
      "dateOfBirth": "string",
      "spaceId": 0,
      "phoneNumber1": "string",
      "phoneNumber2": "string",
      "phoneNumber3": "string",
      "isActive": true,
      "isLegal": true,
      "organizationName": "string",
      "createdAt": "2023-11-25T04:44:37.891Z",
      "updatedAt": "2023-11-25T04:44:37.891Z",
      "isDeactivated": true,
      "deactivationDate": "2023-11-25T04:44:37.891Z",
      "personDeactivatedById": 0,
      "relation": "PARENT"
    }
  ],
  "groups": [
    {"id": 0, "name": "string", "isRole": true, "isActive": true, "spaceId": 0}
  ]
};

enum Role {
  Student,
  Teacher,
  Relative,
}

class PersonModel {
  final int id;
  final int? userId;
  final String? email1;
  final String? email2;
  final String? email3;
  final Map<String, dynamic>? tagsSettings;
  final Map<String, dynamic>? personSettings;
  final String? VATId;
  final String? taxId;
  final String firstName;
  final String? middleName;
  final String lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final int? spaceId;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final bool isActive;
  final bool isLegal;
  final String? organizationName;
  final String createdAt;
  final String updatedAt;
  final bool isDeactivated;
  final String? deactivationDate;
  final int? personDeactivatedById;
  final List<ChildRelation>? childRelations;
  final List<RelativePerson>? relativeRelations;
  final List<Group>? groups;

  // Get Role from 1st group
  get role {
    if (groups != null &&
        groups!.isNotEmpty &&
        groups!.first.isRole != null &&
        groups!.first.isRole!) {
      return groups!.first.name!;
    }
  }

  const PersonModel({
    required this.id,
    this.userId,
    this.email1,
    this.email2,
    this.email3,
    this.tagsSettings,
    this.personSettings,
    this.VATId,
    this.taxId,
    required this.firstName,
    this.middleName,
    required this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.spaceId,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    required this.isActive,
    required this.isLegal,
    this.organizationName,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeactivated,
    this.deactivationDate,
    this.personDeactivatedById,
    this.childRelations,
    this.relativeRelations,
    this.groups,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      userId: json['userId'],
      email1: json['email1'],
      email2: json['email2'],
      email3: json['email3'],
      tagsSettings: json['tagsSettings'],
      personSettings: json['personSettings'],
      VATId: json['VATId'],
      taxId: json['taxId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName1: json['lastName1'],
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      spaceId: json['spaceId'],
      phoneNumber1: json['phoneNumber1'],
      phoneNumber2: json['phoneNumber2'],
      phoneNumber3: json['phoneNumber3'],
      isActive: json['isActive'],
      isLegal: json['isLegal'],
      organizationName: json['organizationName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isDeactivated: json['isDeactivated'],
      deactivationDate: json['deactivationDate'],
      personDeactivatedById: json['personDeactivatedById'],
      childRelations: json['childRelations'] != null
          ? List<ChildRelation>.from(
              json['childRelations'].map((x) => ChildRelation.fromJson(x)))
          : null,
      relativeRelations: json['relativeRelations'] != null
          ? List<RelativePerson>.from(
              json['relativeRelations'].map((x) => RelativePerson.fromJson(x)))
          : null,
      groups: json['groups'] != null
          ? List<Group>.from(json['groups'].map((x) => Group.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email1': email1,
      'email2': email2,
      'email3': email3,
      'tagsSettings': tagsSettings,
      'personSettings': personSettings,
      'VATId': VATId,
      'taxId': taxId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      'spaceId': spaceId,
      'phoneNumber1': phoneNumber1,
      'phoneNumber2': phoneNumber2,
      'phoneNumber3': phoneNumber3,
      'isActive': isActive,
      'isLegal': isLegal,
      'organizationName': organizationName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isDeactivated': isDeactivated,
      'deactivationDate': deactivationDate,
      'personDeactivatedById': personDeactivatedById,
      'childRelations': childRelations != null
          ? childRelations!.map((x) => x.toJson()).toList()
          : null,
      'relativeRelations': relativeRelations != null
          ? relativeRelations!.map((x) => x.toJson()).toList()
          : null,
      'groups': groups != null ? groups!.map((x) => x.toJson()).toList() : null,
    };
  }
}

class ChildRelation {
  final int id;
  final int? userId;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final int? spaceId;
  final bool? isLegal;
  final String? counterpartyName;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? relation;

  const ChildRelation({
    required this.id,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.spaceId,
    this.isLegal,
    this.counterpartyName,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.relation,
  });

  factory ChildRelation.fromJson(Map<String, dynamic> json) {
    return ChildRelation(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName1: json['lastName1'],
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      phoneNumber1: json['phoneNumber1'],
      phoneNumber2: json['phoneNumber2'],
      phoneNumber3: json['phoneNumber3'],
      spaceId: json['spaceId'],
      isLegal: json['isLegal'],
      counterpartyName: json['counterpartyName'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      'phoneNumber1': phoneNumber1,
      'phoneNumber2': phoneNumber2,
      'phoneNumber3': phoneNumber3,
      'spaceId': spaceId,
      'isLegal': isLegal,
      'counterpartyName': counterpartyName,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relation': relation,
    };
  }
}

class RelativePerson {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final String? phoneNumber;
  final int? spaceId;
  final bool? isLegal;
  final String? counterpartyName;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? relation;

  const RelativePerson({
    this.id,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.phoneNumber,
    this.spaceId,
    this.isLegal,
    this.counterpartyName,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.relation,
  });

  factory RelativePerson.fromJson(Map<String, dynamic> json) {
    return RelativePerson(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName1: json['lastName1'],
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      phoneNumber: json['phoneNumber'],
      spaceId: json['spaceId'],
      isLegal: json['isLegal'],
      counterpartyName: json['counterpartyName'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'spaceId': spaceId,
      'isLegal': isLegal,
      'counterpartyName': counterpartyName,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relation': relation,
    };
  }
}

Role stringToRole(String value) {
  switch (value) {
    case "Student":
      return Role.Student;
    case "Relative":
      return Role.Relative;
    case "Parent":
      return Role.Relative;
    case "Teacher":
      return Role.Teacher;
    default:
      return Role.Student;
  }
}
