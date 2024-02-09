import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/verify_phone_numbers/api/verify_phone_number.dart';
import 'package:seymo_pay_mobile_application/data/verify_phone_numbers/model/verify_phone_number_request.dart';

part 'verify_phone_number_event.dart';
part 'verify_phone_number_state.dart';

class VerifyPhoneNumberBloc extends Bloc<VerifyPhoneNumberEvent, VerifyPhoneNumberState> {

  final VerifyPhoneNumberApi phoneNumberVerifyApiImpl;

  VerifyPhoneNumberBloc(this.phoneNumberVerifyApiImpl)
      : super(const VerifyPhoneNumberState(status: VerifyPhoneNumberStatus.initial)) {
    on<ValidateVerifyPhoneNumberEvent>(_verifyPhoneNumber);
  }

  Future<void> _verifyPhoneNumber(
    ValidateVerifyPhoneNumberEvent event,
    Emitter<VerifyPhoneNumberState> emit
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      String verifyPhoneNumberResult = await phoneNumberVerifyApiImpl
        .verifyPhoneNumber(
          event.verifyPhoneNumberRequest
        );
      emit(state.copyWith(
        status: VerifyPhoneNumberStatus.verified,
        verifyPhoneNumberMessage: verifyPhoneNumberResult,
        isLoading: false,
      ));
    } on DioException catch (error) {
      late String responseError;
      /**
       * Parse array of errors as string
       * Accept string error format
      */
      if (error.response!.data['message'] is List) {
        responseError = error.response!.data['message'][0];
      } else {
        responseError = error.response!.data['message'];
      }
      emit(state.copyWith(
        status: VerifyPhoneNumberStatus.unverified,
        verifyPhoneNumberFailure: responseError,
        isLoading: false,
      ));
    }
  }
}
