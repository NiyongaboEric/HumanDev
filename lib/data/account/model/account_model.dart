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
  OTHERS,
}

class AccountsModel {
  final int id;
  final AccountName name;
  final AccountType type;
  final bool supportsMoneyFlow;
  final int spaceId;
  final String createdAt;
  final String updatedAt;

  const AccountsModel({
    required this.id,
    required this.name,
    required this.type,
    required this.supportsMoneyFlow,
    required this.spaceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountsModel.fromJson(Map<String, dynamic> json) {
    return AccountsModel(
      id: json['id'],
      name: accountNameFromString(json['name']),
      type: accountTypeFromString(json['type']),
      supportsMoneyFlow: json['supportsMoneyFlow'],
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
      'supportsMoneyFlow': supportsMoneyFlow,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

// Name Enum to String
AccountName accountNameFromString(String name) {
  return AccountName.values.firstWhere(
      (e) => e.toString().split('.').last == name,
      orElse: () => AccountName.OTHERS);
}

// Type Enum to String
AccountType accountTypeFromString(String type) {
  return AccountType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => AccountType.BALANCE_SHEET);
}
