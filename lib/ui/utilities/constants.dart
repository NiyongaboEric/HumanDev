import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/data/account/model/account_model.dart';

import '../../data/constants/shared_prefs.dart';

var sl = GetIt.instance;

var preferences = sl<SharedPreferenceModule>();

class Constants {
  static const String appName = "Seymo School";

  // List of all alphabets in uppercase
  static const List<String> alphabets = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  // Payment Payment Methods
  static List<AccountsModel> paymentMethods = preferences.getAccounts().where((element) => element.name.name != "ACCOUNTS_RECEIVABLE" || element.name.name != "REVENUE").toList();

  // Currency Options
  static const currencyOptions = ["GHS", "USD", "NGN", "EUR", "INR", "Add "];

  // Gender Options
  static const genders = ["Male", "Female", "Other"];

  // Default Person Types
  static const personTypes = ["Student", "Teacher", "Parent", "Supplier"];

  // Dynamic Person Types
  static const dynamicPersonTypes = ["Other people", "Other organization"];

  // Material Color Conversion
  // Change from color to material color

  // Person Roles
  static const personRoles = [
    // "Student",
    "Parent",
    "Teacher",
    "Supplier",
  ];


  // METHODS

  // Date Format Parser
  static String dateFormatParser(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yy').format(dateTime);
  }
}
