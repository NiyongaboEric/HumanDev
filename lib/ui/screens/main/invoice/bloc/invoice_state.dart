part of 'invoice_bloc.dart';


enum InvoiceStateStatus { initial, success, error }

class InvoiceState {
  final String? id;
  final InvoiceStateStatus? status;
  final bool isLoading;
  final List<InvoiceCreateRequest>? invoiceCreateRequests;
  final List<InvoiceUpdateRequest>? invoiceUpdateRequests;
  final List<InvoiceModel>? invoices;
  final InvoiceResponse? invoiceResponse;
  final String? errorMessage;
  final String? successMessage;

  const InvoiceState({
    this.id,
    this.status,
    this.isLoading = false,
    this.invoiceCreateRequests,
    this.invoiceUpdateRequests,
    this.invoices,
    this.invoiceResponse,
    this.errorMessage,
    this.successMessage,
  });

  InvoiceState copyWith({
    String? id,
    InvoiceStateStatus? status,
    bool? isLoading,
    List<InvoiceCreateRequest>? invoiceCreateRequests,
    List<InvoiceUpdateRequest>? invoiceUpdateRequests,
    List<InvoiceModel>? invoices,
    InvoiceResponse? invoiceResponse,
    String? errorMessage,
    String? successMessage,
  }) {
    return InvoiceState(
      id: id ?? this.id,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      invoiceCreateRequests: invoiceCreateRequests ?? this.invoiceCreateRequests,
      invoiceUpdateRequests: invoiceUpdateRequests ?? this.invoiceUpdateRequests,
      invoices: invoices ?? this.invoices,
      invoiceResponse: invoiceResponse ?? this.invoiceResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
  
}
