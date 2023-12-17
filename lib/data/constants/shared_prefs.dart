import 'dart:convert';

import 'package:seymo_pay_mobile_application/data/account/model/account_model.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';
import 'package:seymo_pay_mobile_application/data/tags/model/tag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../invoice/model/invoice_model.dart';
import '../person/model/person_model.dart';
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

  // Save Invoice to Shared Preferences
  void saveInvoice(List<InvoiceModel> invoiceList){
    final jsonString = jsonEncode(
      invoiceList.map((invoice) => invoice.toJson()).toList(),
    );
    pref.setString("invoice", jsonString);
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

  // Save All Persons to Shared Preferences
  void savePersons(List<PersonModel> persons) {
    final jsonString = jsonEncode(
      persons.map((person) => person.toJson()).toList(),
    );
    pref.setString("persons", jsonString);
  }

  // Save Teachers to Shared Preferences
  void saveTeachers(List<PersonModel> teachers) {
    final jsonString = jsonEncode(
      teachers.map((teacher) => teacher.toJson()).toList(),
    );
    pref.setString("teachers", jsonString);
  }

  void saveSuppliers (List<PersonModel> suppliers) {
    final jsonStrings = jsonEncode(
      suppliers.map((supplier) => supplier.toJson()).toList()
    );
    pref.setString("suppliers", jsonStrings);
  }

  void saveSchoolAdministrator (List<PersonModel> schoolAdministrators) {
    final jsonStrings = jsonEncode(
      schoolAdministrators.map((administrator) => administrator.toJson()).toList()
    );
    pref.setString("schoolAdministrators", jsonStrings);
  }

  // Save Students to Shared Preferences
  void saveStudents(List<PersonModel> students) {
    final jsonString = jsonEncode(
      students.map((student) => student.toJson()).toList(),
    );
    pref.setString("students", jsonString);
  }

  // Save Parents to Shared Preferences
  void saveParents(List<PersonModel> parents) {
    final jsonString = jsonEncode(
      parents.map((parent) => parent.toJson()).toList(),
    );
    pref.setString("parents", jsonString);
  }

  // Save Organizations to Shared Preferences
  void saveOrganizations(List<PersonModel> organizations) {
    final jsonString = jsonEncode(
      organizations.map((organization) => organization.toJson()).toList(),
    );
    pref.setString("organizations", jsonString);
  }

// Retrieve From LocalStorage/SharedPreferences

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
  List<TagModel> getTags() {
    final jsonString = pref.getString("tags");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => TagModel.fromJson(e))
          .toList();
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

  // Get Person Data
  List<PersonModel> getPersons() {
    final jsonString = pref.getString("persons");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => PersonModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // Get Teachers
  List<PersonModel> getTeachers() {
    final jsonString = pref.getString("teachers");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => PersonModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // Get Students
  List<PersonModel> getStudents() {
    final jsonString = pref.getString("students");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => PersonModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // Get Parents
  List<PersonModel> getParents() {
    final jsonString = pref.getString("parents");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => PersonModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // Get Organizations
  List<PersonModel> getOrganizations() {
    final jsonString = pref.getString("organizations");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => PersonModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // Get Invoice
  List<InvoiceModel> getInvoice() {
    final jsonString = pref.getString("invoice");
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List)
          .map((e) => InvoiceModel.fromJson(e))
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
