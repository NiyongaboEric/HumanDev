part of 'paid_money_bloc.dart';

// Paid Money Sate Enum
enum PaidMoneyStatus { initial, success, error }

final class PaidMoneyState {
  final bool isLoading;
  final PaymentModel? paymentRequest;
  final List<PaymentModel> payments;
  final PaidMoneyStatus status;
  final String? successMessage;
  final String? errorMessage;
  final String? defaultSuccess;
  final String? defaultError;

  const PaidMoneyState({
    this.isLoading = false,
    this.paymentRequest = const PaymentModel(),
    this.payments = const <PaymentModel>[],
    this.status = PaidMoneyStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.defaultSuccess,
    this.defaultError,
  });

  PaidMoneyState copyWith({
    bool? isLoading,
    PaymentModel? paymentRequest,
    List<PaymentModel>? payments,
    PaidMoneyStatus? status,
    String? successMessage,
    String? errorMessage,
    String? defaultSuccess,
    String? defaultError,
  }) {
    return PaidMoneyState(
      isLoading: isLoading ?? this.isLoading,
      paymentRequest: paymentRequest ?? this.paymentRequest,
      payments: payments ?? this.payments,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      defaultSuccess: defaultSuccess ?? this.defaultSuccess,
      defaultError: defaultError ?? this.defaultError,
    );
  }
}
