part of 'accounts_bloc.dart';

sealed class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object> get props => [];
}

final class AccountsEventGetAccounts extends AccountsEvent {
  const AccountsEventGetAccounts();
}
