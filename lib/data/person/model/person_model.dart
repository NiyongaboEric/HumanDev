enum Role {
  STUDENT,
  RELATIVE,
}

class PersonModel {
  final int id;
  final int? userId;
  final String firstName;
  final String? middleName;
  final String lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final Role role;
  final int? spaceId;
  final String? phoneNumber;
  final bool? isActive;
  final bool? isLegal;
  final String? counterpartyName;
  final String? createdAt;
  final String? updatedAt;
  final List<RelatedPersons>? relatedPersons;
  final List<PersonRelation>? personRelations;

  const PersonModel({
    required this.id,
    required this.userId,
    required this.firstName,
    this.middleName,
    required this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    required this.role,
    required this.spaceId,
    this.phoneNumber,
    this.isActive,
    this.isLegal,
    this.counterpartyName,
    required this.createdAt,
    required this.updatedAt,
    this.relatedPersons,
    this.personRelations,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName1: json['lastName1'],
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      role: stringToRole(json['role']),
      spaceId: json['spaceId'],
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'],
      isLegal: json['isLegal'],
      counterpartyName: json['counterpartyName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      relatedPersons: json['relatedPersons'] == null
          ? null
          : (json['relatedPersons'] as List)
              .map((e) => RelatedPersons.fromJson(e))
              .toList(),
      personRelations: json['personRelations'] == null
          ? null
          : (json['personRelations'] as List)
              .map((e) => PersonRelation.fromJson(e))
              .toList(),
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
      'role': role.name,
      'spaceId': spaceId,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'isLegal': isLegal,
      'counterpartyName': counterpartyName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relatedPersons': relatedPersons,
    };
  }
}

class RelatedPersons {
  final int id;
  final int? userId;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final String? role;
  final int? spaceId;
  final String? phoneNumber;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? relation;

  const RelatedPersons({
    required this.id,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.role,
    this.spaceId,
    this.phoneNumber,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.relation,
  });

  factory RelatedPersons.fromJson(Map<String, dynamic> json) {
    return RelatedPersons(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName1: json['lastName1'],
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      role: json['role'],
      spaceId: json['spaceId'],
      phoneNumber: json['phoneNumber'],
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
      'role': role,
      'spaceId': spaceId,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relation': relation,
    };
  }
}

class PersonRelation {
  final int? id;
  final int? childPersonId;
  final int? relativePersonId;
  final String? relation;
  final String? createdAt;
  final String? updatedAt;

  const PersonRelation({
    this.id,
    this.childPersonId,
    this.relativePersonId,
    this.relation,
    this.createdAt,
    this.updatedAt,
  });

  factory PersonRelation.fromJson(Map<String, dynamic> json) {
    return PersonRelation(
      id: json['id'],
      childPersonId: json['childPersonId'],
      relativePersonId: json['relativePersonId'],
      relation: json['relation'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childPersonId': childPersonId,
      'relativePersonId': relativePersonId,
      'relation': relation,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

Role stringToRole(String value){
  switch(value){
    case "STUDENT":
      return Role.STUDENT;
    case "RELATIVE":
      return Role.RELATIVE;
    case "PARENT":
      return Role.RELATIVE;
    default:
      return Role.STUDENT;
  }
}