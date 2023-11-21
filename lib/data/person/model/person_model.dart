
enum Role {
  Student,
  Teacher,
  Relative,
}

class PersonModel {
  final int id;
  final int? userId;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? dateOfBirth;
  final int? spaceId;
  final String? phoneNumber;
  final bool? isActive;
  final bool? isLegal;
  final String? counterpartyName;
  final String? createdAt;
  final String? updatedAt;
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
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.dateOfBirth,
    this.spaceId,
    this.phoneNumber,
    this.isActive,
    this.isLegal,
    this.counterpartyName,
    this.createdAt,
    this.updatedAt,
    this.childRelations,
    this.relativeRelations,
    this.groups,
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
      spaceId: json['spaceId'],
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'],
      isLegal: json['isLegal'],
      counterpartyName: json['counterpartyName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      childRelations: json['childRelations'] != null
          ? (json['childRelations'] as List)
              .map((i) => ChildRelation.fromJson(i))
              .toList()
          : null,
      relativeRelations: json['relativeRelations'] != null
          ? (json['relativeRelations'] as List)
              .map((i) => RelativePerson.fromJson(i))
              .toList()
          : null,
      groups: json['groups'] != null
          ? (json['groups'] as List).map((i) => Group.fromJson(i)).toList()
          : null,
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
      'spaceId': spaceId,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'isLegal': isLegal,
      'counterpartyName': counterpartyName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'childRelations': childRelations,
      'relativeRelations': relativeRelations,
      'groups': groups,
    };
  }
}

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

class ChildRelation {
  final int id;
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

  const ChildRelation({
    required this.id,
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

  factory ChildRelation.fromJson(Map<String, dynamic> json) {
    return ChildRelation(
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
