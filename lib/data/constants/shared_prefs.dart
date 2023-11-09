import 'dart:convert';

import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../space/model/space_model.dart';

class SharedPreferenceModule {
  final SharedPreferences pref;
  static const String _TOKEN = "token";

  SharedPreferenceModule({required this.pref});

  void clear() => pref.clear();

  // void saveUserData(String userDataInJson) =>
  //     pref.setString(_TOKEN, userDataInJson);

  // String getUserData() {
  //   String userDataInJson = pref.getString(_TOKEN) ?? "";
  //   return userDataInJson;
  // }

  // Save user data to Shared Preferences
  void saveToken(TokenResponse user) {
    final jsonString = user.toJson();
    pref.setString("token", jsonEncode(jsonString));
  }

  // Save Space Data
void saveSpaces(List<Space> spaces) {
  final jsonString = jsonEncode(
    spaces.map((space) => space.toJson()).toList(),
  );
  pref.setString("spaces", jsonString);
}


  // Get user data from Shared Preferences
  TokenResponse? getToken() {
    final jsonString = pref.getString("token");
    if (jsonString != null) {
      return TokenResponse.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  // Get Space Data
List<Space> getSpaces() {
  final jsonString = pref.getString("spaces");
  if (jsonString != null) {
    return (jsonDecode(jsonString) as List)
        .map((e) => Space.fromJson(e))
        .toList();
  }
  return [];
}

  // Clear user data from Shared Preferences
  void clearData() {
    pref.remove("token");
  }

  // Clear Space Data
  void clearSpaces() {
    pref.setString("spaces", "[]");
  }
}
