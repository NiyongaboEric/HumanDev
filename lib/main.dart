import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/accounts_bloc/accounts_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/fullpage_loader_auth.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/space_bloc/space_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/tags_bloc/tags_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/sms/bloc/sms_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/bloc/person_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';

import 'data/constants/shared_prefs.dart';
import 'ui/screens/auth/group_bloc/groups_bloc.dart';
import 'ui/screens/main/reminder/blocs/reminder_bloc.dart';
import 'utilities/dependency_injection.dart';

final sl = GetIt.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sl.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pref = sl.get<SharedPreferenceModule>();
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<AuthBloc>()),
                BlocProvider(create: (context) => sl<PersonBloc>()),
                BlocProvider(create: (context) => sl<JournalBloc>()),
                BlocProvider(create: (context) => sl<AccountsBloc>()),
                BlocProvider(create: (context) => sl<SpaceBloc>()),
                BlocProvider(create: (context) => sl<ReminderBloc>()),
                BlocProvider(create: (context) => sl<TagsBloc>()),
                BlocProvider(create: (context) => sl<GroupsBloc>()),
                BlocProvider(create: (context) => SMSBloc()),
              ],
              child: MaterialApp(
                title: 'Seymo Pay',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFFF5E8D3),
                  ),
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Color(0xFFF5E8D3),
                    selectionColor: Color(0xFFF5E8D3),
                  ),
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    titleTextStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    centerTitle: true,
                  ),
                ),
                home: pref.getToken() == null
                    ? const LoginScreen()
                    : const FullPageLoaderAuth(),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
