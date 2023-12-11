part of 'invoice_bloc.dart';


enum InvoiceStateStatus { initial, success, error }

class InvoiceState {
  final String? id;
  final InvoiceStateStatus? status;
  final bool isLoading;
  final List<InvoiceRequest>? invoiceRequests;
  final List<InvoiceModel>? invoices;
  final InvoiceModel? invoiceResponse;
  final String? errorMessage;
  final String? successMessage;

  const InvoiceState({
    this.id,
    this.status,
    this.isLoading = false,
    this.invoiceRequests,
    this.invoices,
    this.invoiceResponse,
    this.errorMessage,
    this.successMessage,
  });

  InvoiceState copyWith({
    String? id,
    InvoiceStateStatus? status,
    bool? isLoading,
    List<InvoiceRequest>? invoiceRequests,
    List<InvoiceModel>? invoices,
    InvoiceModel? invoiceResponse,
    String? errorMessage,
    String? successMessage,
  }) {
    return InvoiceState(
      id: id ?? this.id,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      invoiceRequests: invoiceRequests ?? this.invoiceRequests,
      invoices: invoices ?? this.invoices,
      invoiceResponse: invoiceResponse ?? this.invoiceResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
  
}
