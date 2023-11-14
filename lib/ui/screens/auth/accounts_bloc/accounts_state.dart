part of 'accounts_bloc.dart';

enum AccountsStateStatus {
  initial,
  success,
  error,
}

class AccountsState {
  final AccountsStateStatus status;
  final List<AccountsModel> accounts;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const AccountsState({
    this.status = AccountsStateStatus.initial,
    this.accounts = const [],
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  AccountsState copyWith({
    AccountsStateStatus? status,
    List<AccountsModel>? accounts,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
