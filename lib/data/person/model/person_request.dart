import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';

class PersonRequest {
  final int? id;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? gender;
  final String? dateOfBirth;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final Address? address;
  final String? email1;
  final String? email2;
  final String? email3;
  final String? taxId;
  final String?  VATId;
  final bool isLegal;
  final List<PersonRelativeRelation>? personRelativeRelations;
  final List<PersonChildRelation>? personChildRelations;
  final String? organizationName;
  final List<int>? groupIds;

  const PersonRequest({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.address,
    this.email1,
    this.email2,
    this.email3,
    this.VATId,
    this.gender,
    this.taxId,
    this.dateOfBirth,
    required this.isLegal,
    this.personRelativeRelations,
    this.personChildRelations,
    this.organizationName,
    this.groupIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'dateOfBirth': dateOfBirth,
      "phoneNumber1": phoneNumber1,
      "phoneNumber2": phoneNumber2,
      "phoneNumber3": phoneNumber3,
      "address": address?.toJson(),
      "email1": email1,
      "email2": email2,
      "email3": email3,
      "taxId": taxId,
      "VATId": VATId,      
      'isLegal': isLegal,
      'personRelativeRelations': personRelativeRelations?.map((e) => e.toJson()).toList(),
      "personChildRelations": personChildRelations?.map((e) => e.toJson()).toList(),
      'organizationName': organizationName,
      'groupIds': groupIds,
    };
  }
}

class UpdatePersonRequest {
  final int? id;
  final String? firstName;
  final String? middleName;
  final String? lastName1;
  final String? lastName2;
  final String? gender;
  final String? dateOfBirth;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final Address? address;
  final String? email1;
  final String? email2;
  final String? email3;
  final String? taxId;
  final String?  VATId;
  final bool isLegal;
  final String? organizationName;
  final List<int>? connectGroupIds;
  final List<int>? disconnectGroupIds;
  final List<PersonRelativeRelation>? connectPersonRelativeRelations;
  final List<int>? disconnectPersonRelativeRelations;
  final List<PersonChildRelation>? connectPersonChildRelations;
  final List<int>? disconnectPersonChildRelations;
  final bool isDeactivated;

  const UpdatePersonRequest({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName1,
    this.lastName2,
    this.gender,
    this.dateOfBirth,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.address,
    this.email1,
    this.email2,
    this.email3,
    this.taxId,
    this.VATId,
    required this.isLegal,
    this.organizationName,
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
      // 'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'phoneNumber1': phoneNumber1,
      'phoneNumber2': phoneNumber2,
      'phoneNumber3': phoneNumber3,
      'isLegal': isLegal,
      'organizationName': organizationName,
      'address': address?.toJson(),
      'email1': email1,
      'email2': email2,
      'email3': email3,
      'taxId': taxId,
      'VATId': VATId,
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

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? zip;

  const Address({
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }
}

class PersonRelativeRelation {
  final int? childPersonId;
  final String? relation;

  const PersonRelativeRelation({
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

class PersonChildRelation {
  final int? relativePersonId;
  final String? relation;

  const PersonChildRelation({
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