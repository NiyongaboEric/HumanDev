import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/dio_config.dart';
import 'package:seymo_pay_mobile_application/data/reminders/api/reminder_api.dart';
import 'package:seymo_pay_mobile_application/data/space/api/space_api.dart';
import 'package:seymo_pay_mobile_application/data/person/api/person_api.dart';
import 'package:seymo_pay_mobile_application/data/journal/api/tuition_fees_api.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/space_bloc/space_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth/api/auth_api.dart';
import '../data/constants/request_interceptor.dart';
import '../data/constants/shared_prefs.dart';
import '../data/payment/api/payment_api.dart';
import '../ui/screens/auth/auth_bloc/auth_bloc.dart';
import '../ui/screens/main/person/bloc/person_bloc.dart';
import '../ui/screens/main/reminder/blocs/reminder_bloc.dart';
import '../ui/screens/main/transaction_records/paid_money/bloc/paid_money_bloc.dart';

Future<void> init() async {
  final sl = GetIt.instance;

  // Pref
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  sl.registerSingletonWithDependencies<SharedPreferenceModule>(
    () => SharedPreferenceModule(pref: sl<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  // Request Interceptor (Registered before NetworkModule)
  sl.registerSingletonWithDependencies<RequestInterceptor>(
    () => RequestInterceptor(pref: sl<SharedPreferenceModule>()),
    dependsOn: [SharedPreferenceModule],
  );

  // Network Module (Depends on RequestInterceptor)
  sl.registerLazySingleton<Dio>(
    () => DioConfig(requestInterceptor: sl<RequestInterceptor>()).provideDio(),
  );

  // Api Data Source
  sl.registerSingleton<AuthApiImpl>(AuthApiImpl());
  sl.registerSingleton<PersonApiImpl>(PersonApiImpl());
  sl.registerSingleton<JournalApiImpl>(JournalApiImpl());
  sl.registerSingleton<PaymentApiImpl>(PaymentApiImpl());
  sl.registerSingleton<SpaceApiImpl>(SpaceApiImpl());
  sl.registerSingleton<ReminderApiImpl>(ReminderApiImpl());
  // sl.registerSingleton<ProfileApiImpl>(ProfileApiImpl());

  // Blocs
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl<SharedPreferenceModule>(), sl<AuthApiImpl>()));
  sl.registerFactory<PersonBloc>(() => PersonBloc(sl<PersonApiImpl>()));
  sl.registerFactory<JournalBloc>(() => JournalBloc(sl<JournalApiImpl>()));
  sl.registerFactory<PaidMoneyBloc>(() => PaidMoneyBloc(sl<PaymentApiImpl>()));
  sl.registerFactory<SpaceBloc>(
      () => SpaceBloc(sl<SharedPreferenceModule>(), sl<SpaceApiImpl>()));
  sl.registerFactory<ReminderBloc>(
      () => ReminderBloc(sl<ReminderApiImpl>()));
  // sl.registerFactory<PaymentBloc>(() => PaymentBloc(sl<PaymentApiImpl>()));
  // sl.registerFactory(
  //     () => ProfileBloc(sl<SharedPreferenceModule>(), sl<ProfileApiImpl>()));
}
