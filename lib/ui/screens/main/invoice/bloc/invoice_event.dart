part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();
  
  @override
  List<Object> get props => [];
}

final class InvoiceEventGetAllInvoices extends InvoiceEvent {
  const InvoiceEventGetAllInvoices();
  
  @override
  List<Object> get props => [];
}

final class InvoiceGetOneInvoice extends InvoiceEvent {
  final String id;

  const InvoiceGetOneInvoice(this.id);
  
  @override
  List<Object> get props => [];
}

final class InvoiceEventCreateInvoice extends InvoiceEvent {
  final InvoiceRequest invoiceRequest;

  const InvoiceEventCreateInvoice(this.invoiceRequest);
  
  @override
  List<Object> get props => [];
}

final class InvoiceUpdateInvoice extends InvoiceEvent {
  final InvoiceRequest invoiceRequest;
  final String id;

  const InvoiceUpdateInvoice(this.invoiceRequest, this.id);
  
  @override
  List<Object> get props => [];
}

final class InvoiceEventDeleteInvoice extends InvoiceEvent {
  final String id;

  const InvoiceEventDeleteInvoice(this.id);
  
  @override
  List<Object> get props => [];
}
