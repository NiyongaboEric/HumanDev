import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/invoice/api/invoice_api.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_model.dart';

import '../../../../../data/invoice/model/invoice_request.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceApiImpl invoiceApiImpl;
  final SharedPreferenceModule sharedPreferenceModule;
  InvoiceBloc(this.sharedPreferenceModule, this.invoiceApiImpl) : super(const InvoiceState()) {
    on<InvoiceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InvoiceEventGetAllInvoices>((event, emit) => _getAllInvoices(event, emit));
    // on<InvoiceGetOneInvoice>((event, emit) => _getOneInvoice(event, emit));
    // on<InvoiceEventCreateInvoice>((event, emit) => _createInvoice(event, emit));
    // on<InvoiceUpdateInvoice>((event, emit) => _updateInvoice(event, emit));
    // on<InvoiceEventDeleteInvoice>((event, emit) => _deleteInvoice(event, emit));
  }

  // Get All Invoices
  Future<void> _getAllInvoices(InvoiceEventGetAllInvoices event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final invoices = await invoiceApiImpl.getInvoices();
      sharedPreferenceModule.saveInvoice(invoices);
      emit(state.copyWith(
          status: InvoiceStateStatus.success,
          invoices: invoices,
          isLoading: false,
          successMessage: "Invoice"));
    } on DioException catch (error) {
      emit(state.copyWith(
        errorMessage: error.response?.data['message'] ?? "Network Error",
        isLoading: false,
        status: InvoiceStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        status: InvoiceStateStatus.initial,
        errorMessage: null,
        successMessage: null,
        isLoading: false,
      ));
    }
  }
}
