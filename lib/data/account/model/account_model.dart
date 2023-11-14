
// Enum Type
enum AccountType {
  BALANCE_SHEET,
  PROFIT_LOSS,
}

// Enum Name
enum AccountName {
  ACCOUNTS_RECEIVABLE,
  CASH,
  REVENUE,
  BANK_ACCOUNT,
  MOMO,
}

class AccountsModel {
  final int id;
  final AccountName name;
  final AccountType type;
  final int spaceId;
  final String createdAt;
  final String updatedAt;

  const AccountsModel({
    required this.id,
    required this.name,
    required this.type,
    required this.spaceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountsModel.fromJson(Map<String, dynamic> json) {
    return AccountsModel(
      id: json['id'],
      name: accountNameFromString(json['name']),
      type: accountTypeFromString(json['type']),
      spaceId: json['spaceId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.name,
      'type': type.name,
      'spaceId': spaceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

// Name Enum to String
AccountName accountNameFromString(String name) {
  switch (name) {
    case "ACCOUNTS_RECEIVABLE":
      return AccountName.ACCOUNTS_RECEIVABLE;
    case "CASH":
      return AccountName.CASH;
    case "REVENUE":
      return AccountName.REVENUE;
    case "BANK_ACCOUNT":
      return AccountName.BANK_ACCOUNT;
    case "MOMO":
      return AccountName.MOMO;
    default:
      return AccountName.ACCOUNTS_RECEIVABLE;
  }
}

// Type Enum to String
AccountType accountTypeFromString(String type) {
  switch (type) {
    case "BALANCE_SHEET":
      return AccountType.BALANCE_SHEET;
    case "PROFIT_LOSS":
      return AccountType.PROFIT_LOSS;
    default:
      return AccountType.BALANCE_SHEET;
  }
}
