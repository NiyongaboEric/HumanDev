import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/account/model/account_model.dart';

import '../../../../data/account/api/account_api.dart';
import '../../../../data/constants/shared_prefs.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final AccountApiImpl accountApiImpl;
  final SharedPreferenceModule sharedPreferenceModule;
  AccountsBloc(this.accountApiImpl, this.sharedPreferenceModule) : super(const AccountsState()) {
    on<AccountsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AccountsEventGetAccounts>(_getAccounts);
  }

  Future<void> _getAccounts(
      AccountsEventGetAccounts event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final accounts = await accountApiImpl.getAccounts();
      sharedPreferenceModule.saveAccounts(accounts);
      emit(state.copyWith(
          status: AccountsStateStatus.success,
          accounts: accounts,
          isLoading: false,
          successMessage: ""));
    } on DioException catch (error) {
      emit(state.copyWith(
        status: AccountsStateStatus.error,
        isLoading: false,
        errorMessage: error.response?.data['message'] ?? "No internet access",
        accounts: [],
      ));
    } finally {
      emit(state.copyWith(
        status: AccountsStateStatus.initial,
        isLoading: false,
        errorMessage: null,
        successMessage: null,
      ));
    }
  }
}
