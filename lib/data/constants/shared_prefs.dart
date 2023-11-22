import 'dart:convert';

import 'package:seymo_pay_mobile_application/data/account/model/account_model.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/data/tags/model/tag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../space/model/space_model.dart';

class SharedPreferenceModule {
  final SharedPreferences pref;

  SharedPreferenceModule({required this.pref});

  void clear() => pref.clear();

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

// Save Accounts Data to Shared Preferences
  void saveAccounts(List<AccountsModel> accounts) {
    final jsonString = jsonEncode(
      accounts.map((account) => account.toJson()).toList(),
    );
    pref.setString("accounts", jsonString);
  }

  // Save Tags to Shared Preferences
  void saveTags(List<TagModel> tags) {
    final jsonString = jsonEncode(
      tags.map((tag) => tag.toJson()).toList(),
    );
    pref.setString("tags", jsonString);
  }

  // Save Groups to Shared Preferences
  void saveGroups(List<Group> groups) {
    final jsonString = jsonEncode(
      groups.map((group) => group.toJson()).toList(),
    );
    pref.setString("groups", jsonString);
  }

  // Save One Group to Shared Preferences and add to groups list
  void saveGroup(Group group) {
    var groups = getGroups();
    groups.add(group);
    List<Group> newGroupList = groups;
    saveGroups(newGroupList);
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

// Get Accounts Data
  List<AccountsModel> getAccounts() {
    final jsonString = pref.getString("accounts");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => AccountsModel.fromJson(e))
          .toList();
    }
    return [];
  }

// Get Tags
  List<String> getTags() {
    final jsonString = pref.getString("tags");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List).cast<String>();
    }
    return [];
  }

// Get Groups
  List<Group> getGroups() {
    final jsonString = pref.getString("groups");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => Group.fromJson(e))
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
