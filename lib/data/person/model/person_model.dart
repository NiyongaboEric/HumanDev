import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_model.dart';

import '../../groups/model/group_model.dart';
import 'person_request.dart';

var schema = {
  "id": 150,
  "userId": 1037,
  "firstName": "Seymo",
  "middleName": null,
  "lastName1": "Demo",
  "lastName2": null,
  "dateOfBirth": null,
  "phoneNumber1": "+233534578211",
  "phoneNumber2": null,
  "phoneNumber3": null,
  "email1": "demo@seymo.com",
  "email2": null,
  "email3": null,
  "taxId": null,
  "VATId": null,
  "gender": null,
  "address": {},
  "spaceId": 47,
  "tagsSettings": {
    "paidMoney": [
      {"id": 2705, "name": "Salary"},
      {"id": 2752, "name": "Utility bills"},
      {"id": 2799, "name": "Office supplies"},
      {"id": 2846, "name": "Books"},
      {"id": 2893, "name": "Instructional materials"},
      {"id": 2940, "name": "Telecom"},
      {"id": 2987, "name": "IT / Electronics"},
      {"id": 3034, "name": "Food"},
      {"id": 3081, "name": "Rent"}
    ],
    "reminders": {
      "letter": [
        {
          "name": "Financials",
          "tags": [
            null,
            {"id": 2000, "name": "New payment schedule"},
            {"id": 3754, "name": "Amount Due"}
          ],
          "type": "multiple-choice"
        },
        {
          "name": "Warnings",
          "tags": [
            {"id": 3705, "name": "Other"},
            {"id": 2047, "name": "Exam"},
            {"id": 2094, "name": "Suspension"},
            {"id": 2141, "name": "Sacking"},
            {"id": 2188, "name": "Police"}
          ],
          "type": "multiple-choice"
        },
        {
          "name": "Kids",
          "tags": [
            {"id": 3705, "name": "Other"},
            {"id": 2282, "name": "Learning process"},
            {"id": 2329, "name": "Attendance"},
            {"id": 2376, "name": "Health"},
            {"id": 2423, "name": "Behaviour"}
          ],
          "type": "multiple-choice"
        }
      ],
      "conversation": [
        {
          "name": "Location",
          "tags": [
            {"id": 3705, "name": "Other"},
            {"id": 1765, "name": "Office"},
            {"id": 1812, "name": "Parent's home"},
            {"id": 1859, "name": "In public"}
          ],
          "type": "single-choice"
        },
        {
          "name": "Financials",
          "tags": [
            {"id": 1953, "name": "Financial situation of parents"},
            {"id": 2000, "name": "New payment schedule"}
          ],
          "type": "multiple-choice"
        },
        {
          "name": "Warnings",
          "tags": [
            {"id": 3705, "name": "Other"},
            {"id": 2047, "name": "Exam"},
            {"id": 2094, "name": "Suspension"},
            {"id": 2141, "name": "Sacking"},
            {"id": 2188, "name": "Police"}
          ],
          "type": "multiple-choice"
        },
        {
          "name": "Kids",
          "tags": [
            {"id": 3705, "name": "Other"},
            {"id": 2282, "name": "Learning process"},
            {"id": 2329, "name": "Attendance"},
            {"id": 2376, "name": "Health"},
            {"id": 2423, "name": "Behaviour"}
          ],
          "type": "multiple-choice"
        },
        {
          "name": "Atmosphere",
          "tags": [
            [
              {"id": 2517, "name": "Friendly"},
              {"id": 2564, "name": "Hostile"}
            ],
            [
              {"id": 2611, "name": "Owning it"},
              {"id": 2658, "name": "Excuses"}
            ]
          ],
          "type": "opposite"
        }
      ]
    },
    "receivedMoney": [
      {"id": 3081, "name": "Rent"},
      {"id": 3128, "name": "Tution fee"},
      {"id": 3175, "name": "Feeding fee"},
      {"id": 3222, "name": "Exam fee"},
      {"id": 3269, "name": "Enrollment fee"},
      {"id": 3316, "name": "Technology fee"},
      {"id": 3363, "name": "Book fee"},
      {"id": 3410, "name": "Uniform fee"}
    ]
  },
  "personSettings": {},
  "isLegal": false,
  "organizationName": null,
  "createdAt": "2023-11-20T11:41:22.369Z",
  "updatedAt": "2023-11-20T11:41:22.369Z",
  "isDeactivated": false,
  "deactivationDate": null,
  "personDeactivatedById": null
};

enum Role {
  Student,
  Teacher,
  Supplier,
  School_administrator,
  Parent
}

class PersonModel {
  final int id;
  final int? userId;
  final String? email1;
  final String? email2;
  final String? email3;
  final TagsSettings? tagsSettings;
  final Map<String, dynamic>? personSettings;
  final String? VATId;
  final String? taxId;
  final String firstName;
  final String? middleName;
  final String lastName1;
  final String? lastName2;
  final String? gender;
  final String? dateOfBirth;
  final int? spaceId;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final Address? address;
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
  final int? totalDue;
  final List<InvoiceModel>? studentInvoices;
  final String? notes;

  // Get Role from 1st group
  String? get role {
    if (groups != null &&
        groups!.isNotEmpty &&
        groups!.first.isRole != null &&
        groups!.first.isRole!) {
      return groups!.first.name!;
    }
    return null;
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
    this.gender,
    this.spaceId,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.address,
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
    this.totalDue,
    this.studentInvoices,
    this.notes
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      userId: json['userId'],
      email1: json['email1'],
      email2: json['email2'],
      email3: json['email3'],
      tagsSettings: json['tagsSettings'] != null
          ? TagsSettings.fromJson(json['tagsSettings'])
          : null,
      personSettings: json['personSettings'],
      VATId: json['VATId'],
      taxId: json['taxId'],
      firstName: json['firstName'] != null ? "${toBeginningOfSentenceCase(json['firstName'])}" :  "First name",
      middleName: json['middleName'],
      lastName1: json['lastName1'] != null ? "${toBeginningOfSentenceCase(json['lastName1'])}" :  "Last name",
      lastName2: json['lastName2'],
      dateOfBirth: json['dateOfBirth'],
      gender: json["gender"],
      spaceId: json['spaceId'],
      phoneNumber1: json['phoneNumber1'],
      phoneNumber2: json['phoneNumber2'],
      phoneNumber3: json['phoneNumber3'],
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
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
      totalDue: json['totalDue'],
      studentInvoices: json['studentInvoices'] != null
          ? List<InvoiceModel>.from((json['studentInvoices'] as List)
              .map((x) => InvoiceModel.fromJson(x)))
          : null,
      notes: json['notes']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email1': email1,
      'email2': email2,
      'email3': email3,
      'tagsSettings': tagsSettings != null ? tagsSettings!.toJson() : null,
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
      'address': address != null ? address!.toJson() : null,
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
      'notes': notes
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
  // final bool? isActive;
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
    // this.isActive,
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
      // isActive: json['isActive'],
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
      // 'isActive': isActive,
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
  // final bool? isActive;
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
    // this.isActive,
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
      // isActive: json['isActive'],
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
      // 'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relation': relation,
    };
  }
}

class TagsSettings {
  final List<DefaultTagsSettings>? paidMoney;
  final RemindersSettings? reminders;
  final List<DefaultTagsSettings>? receivedMoney;

  const TagsSettings({
    this.paidMoney,
    this.reminders,
    this.receivedMoney,
  });

  factory TagsSettings.fromJson(Map<String, dynamic> json) {
    return TagsSettings(
      paidMoney: json['paidMoney'] != null
          ? (json['paidMoney'] as List<dynamic>)
              .map((x) => DefaultTagsSettings.fromJson(x))
              .toList()
          : null,
      reminders: json['reminders'] != null
          ? RemindersSettings.fromJson(json['reminders'])
          : null,
      receivedMoney: json['receivedMoney'] != null
          ? (json['receivedMoney'] as List<dynamic>)
              .map((x) => DefaultTagsSettings.fromJson(x))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paidMoney':
          paidMoney != null ? paidMoney!.map((x) => x.toJson()).toList() : null,
      'reminders': reminders != null ? reminders!.toJson() : null,
      'receivedMoney': receivedMoney != null
          ? receivedMoney!.map((x) => x.toJson()).toList()
          : null,
    };
  }
}

class DefaultTagsSettings {
  final int? id;
  final String? name;

  const DefaultTagsSettings({
    this.id,
    this.name,
  });

  factory DefaultTagsSettings.fromJson(Map<String, dynamic> json) {
    return DefaultTagsSettings(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class RemindersSettings {
  final List<LetterReminderSettings>? letter;
  final List<ConversationReminderSettings>? conversation;

  const RemindersSettings({
    this.letter,
    this.conversation,
  });

  factory RemindersSettings.fromJson(Map<String, dynamic> json) {
    return RemindersSettings(
      letter: json['letter'] != null
          ? (json['letter'] as List<dynamic>)
              .map((x) => LetterReminderSettings.fromJson(x))
              .toList()
          : null,
      conversation: json['conversation'] != null
          ? (json['conversation'] as List<dynamic>)
              .map((x) => ConversationReminderSettings.fromJson(x))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'letter': letter != null ? letter!.map((x) => x.toJson()).toList() : null,
      'conversation': conversation != null
          ? conversation!.map((x) => x.toJson()).toList()
          : null,
    };
  }
}

class LetterReminderSettings {
  final String? name;
  final List<DefaultTagsSettings>? tags;
  final String? type;

  const LetterReminderSettings({
    this.name,
    this.tags,
    this.type,
  });

  factory LetterReminderSettings.fromJson(Map<String, dynamic> json) {
    return LetterReminderSettings(
      name: json['name'],
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>)
              .map((x) => DefaultTagsSettings.fromJson(x))
              .toList()
          : null,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tags': tags != null ? tags!.map((x) => x.toJson()).toList() : null,
      'type': type,
    };
  }
}

class ConversationReminderSettings {
  final String? name;
  final List<dynamic>? tags;
  final String? type;

  const ConversationReminderSettings({
    this.name,
    this.tags,
    this.type,
  });

  factory ConversationReminderSettings.fromJson(Map<String, dynamic> json) {
    return ConversationReminderSettings(
      name: json['name'],
      tags: json['tags'] != null ? (json['tags']) : null,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tags': tags != null ? tags!.map((x) => x).toList() : null,
      'type': type,
    };
  }
}

Role stringToRole(String value) {
  switch (value) {
    case "Student":
      return Role.Student;
    case "Parent":
      return Role.Parent;
    case "Teacher":
      return Role.Teacher;
    default:
      return Role.Student;
  }
}

String roleToString(Enum value) {
  switch (value) {
    case Role.Supplier:
      return "Supplier";
    case Role.School_administrator:
      return "School administrator";
    case Role.Teacher:
      return "Teacher";
    case Role.Parent:
      return "Parent";
    default:
      return "Student";
  }
}
