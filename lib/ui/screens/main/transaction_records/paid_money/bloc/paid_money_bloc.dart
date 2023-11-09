import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/payment/api/payment_api.dart';
import 'package:seymo_pay_mobile_application/data/payment/model/payment_model.dart';
import 'package:seymo_pay_mobile_application/data/payment/model/requst_model.dart';

part 'paid_money_event.dart';
part 'paid_money_state.dart';

class PaidMoneyBloc extends Bloc<PaidMoneyEvent, PaidMoneyState> {
  final PaymentApiImpl paymentApiImpl;
  PaidMoneyBloc(this.paymentApiImpl) : super(const PaidMoneyState()) {
    on<GetAllPaidMoneyEvent>(_getAllPayment);
    on<AddNewPaidMoneyEvent>(_addNewPayment);
    on<SaveDataPaidMoneyState>(_saveData);
    on<ClearDataPaidMoneyState>(_clearData);
  }

  Future _getAllPayment(
      GetAllPaidMoneyEvent event, Emitter<PaidMoneyState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final payments = await paymentApiImpl.getAllPayment();
      emit(state.copyWith(
        payments: payments,
        isLoading: false,
        status: PaidMoneyStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: PaidMoneyStatus.error,
      ));
    }
  }

  Future _addNewPayment(
      AddNewPaidMoneyEvent event, Emitter<PaidMoneyState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final payment = await paymentApiImpl.createPayment(event.paymentRequest);
      emit(state.copyWith(
        paymentRequest: payment,
        successMessage: "Record Successfully Created",
        isLoading: false,
        status: PaidMoneyStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
        isLoading: false,
        status: PaidMoneyStatus.error,
      ));
    }
  }

  // Save Data
  _saveData(SaveDataPaidMoneyState event, Emitter<PaidMoneyState> emit) {
    try {
      emit(state.copyWith(
        paymentRequest: event.paymentRequest,
        defaultSuccess: "Data Saved Successfully",
        status: PaidMoneyStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          defaultError: e.toString(),
          status: PaidMoneyStatus.error,
        ));
        logger.e(e);
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: PaidMoneyStatus.initial,
        defaultError: null,
        defaultSuccess: null,
      ));
    }
  }

  // clear data
  _clearData(ClearDataPaidMoneyState event, Emitter<PaidMoneyState> emit) {
    try {
      emit(state.copyWith(
        paymentRequest: null,
        defaultSuccess: "Data Cleared Successfully",
        status: PaidMoneyStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        defaultError: e.toString(),
        status: PaidMoneyStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: PaidMoneyStatus.initial,
        defaultError: null,
        defaultSuccess: null,
      ));
    }
  }
}
