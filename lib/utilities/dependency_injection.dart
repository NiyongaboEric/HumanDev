import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/account/api/account_api.dart';
import 'package:seymo_pay_mobile_application/data/constants/dio_config.dart';
import 'package:seymo_pay_mobile_application/data/groups/api/group_api.dart';
import 'package:seymo_pay_mobile_application/data/journal/api/journal_api.dart';
import 'package:seymo_pay_mobile_application/data/person/api/person_api.dart';
import 'package:seymo_pay_mobile_application/data/reminders/api/reminder_api.dart';
import 'package:seymo_pay_mobile_application/data/space/api/space_api.dart';
import 'package:seymo_pay_mobile_application/data/tags/api/tag_api.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/space_bloc/space_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth/api/auth_api.dart';
import '../data/constants/request_interceptor.dart';
import '../data/constants/shared_prefs.dart';
import '../ui/screens/auth/accounts_bloc/accounts_bloc.dart';
import '../ui/screens/auth/auth_bloc/auth_bloc.dart';
import '../ui/screens/auth/group_bloc/groups_bloc.dart';
import '../ui/screens/auth/tags_bloc/tags_bloc.dart';
import '../ui/screens/main/person/bloc/person_bloc.dart';
import '../ui/screens/main/reminder/blocs/reminder_bloc.dart';

Future<void> init() async {
  final sl = GetIt.instance;

  // Pref / LocalStorage
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
  sl.registerSingleton<AccountApiImpl>(AccountApiImpl());
  sl.registerSingleton<TagApiImpl>(TagApiImpl());
  sl.registerSingleton<GroupApiImpl>(GroupApiImpl());
  sl.registerSingleton<SpaceApiImpl>(SpaceApiImpl());
  sl.registerSingleton<ReminderApiImpl>(ReminderApiImpl());

  // Blocs
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl<SharedPreferenceModule>(), sl<AuthApiImpl>()));
  sl.registerFactory<PersonBloc>(() => PersonBloc(sl<PersonApiImpl>()));
  sl.registerFactory<JournalBloc>(() => JournalBloc(sl<JournalApiImpl>()));
  sl.registerFactory<AccountsBloc>(() => AccountsBloc(sl<AccountApiImpl>(), sl<SharedPreferenceModule>()));
  sl.registerFactory<TagsBloc>(() => TagsBloc(sl<TagApiImpl>(), sl<SharedPreferenceModule>()));
  sl.registerFactory<GroupsBloc>(() => GroupsBloc(sl<SharedPreferenceModule>(), sl<GroupApiImpl>()));
  sl.registerFactory<SpaceBloc>(
      () => SpaceBloc(sl<SharedPreferenceModule>(), sl<SpaceApiImpl>()));
  sl.registerFactory<ReminderBloc>(() => ReminderBloc(sl<ReminderApiImpl>()));
}
