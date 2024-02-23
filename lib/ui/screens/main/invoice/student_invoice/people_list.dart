import 'dart:convert';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/group_bloc/groups_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/invoice_list/invoice_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../data/auth/model/auth_request.dart';
import '../../../../../data/auth/model/auth_response.dart';
import '../../../../../data/constants/logger.dart';
import '../../../../../data/constants/shared_prefs.dart';
import '../../../../../data/person/model/person_model.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/custom_colors.dart';
import '../../../../utilities/font_sizes.dart';
import '../../../../utilities/navigation.dart';
import '../../../../widgets/inputs/drop_down_menu.dart';
import '../../../../widgets/inputs/text_field.dart';
import '../../../auth/auth_bloc/auth_bloc.dart';
import '../../person/bloc/person_bloc.dart';

var sl = GetIt.instance;

enum PersonType { STUDENT, THIRD_PARTY }

class PeopleListInvoice extends StatefulWidget {
  const PeopleListInvoice({
    super.key,
  });

  @override
  State<PeopleListInvoice> createState() => _PeopleListInvoiceState();
}

class _PeopleListInvoiceState extends State<PeopleListInvoice> {
  TextEditingController searchController = TextEditingController();
  var prefs = sl<SharedPreferenceModule>();
  var preferences = sl<SharedPreferences>();
  bool showResults = false;
  bool logout = false;
  bool isCurrentPage = true;
  List<PersonModel> searchResults = [];
  List<PersonModel> people = [];
  List<PersonModel> selectedPeople = [];
  String errorMsg = "";
  late List<AlphabetListViewItemGroup> personAlphabetView;
  late List<AlphabetListViewItemGroup> searchResultAlphabetView;
  List<Group> roleGroups = [];
  List<Group> nonRoleGroups = [];
  String selectedGroup = "All groups";
  bool isSelect = false;

  // Update Groups
  _updateGroups(value) {
    setState(() {
      selectedGroup = value!;
    });
  }

  // Set Selected People
  void _onSelected(bool selected, PersonModel dataName) {
    if (selected == true) {
      setState(() {
        selectedPeople.add(dataName);
      });
    } else {
      setState(() {
        selectedPeople.remove(dataName);
      });
    }
  }

  // Search Function
  search(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showResults = false;
      });
    } else {
      setState(() {
        showResults = true;
        searchResults = people
            .toSet()
            .toList()
            .where((student) =>
                student.firstName.toLowerCase().contains(query) ||
                (student.middleName ?? "").toLowerCase().contains(query) ||
                student.lastName1.toLowerCase().contains(query) ||
                (student.lastName2 ?? "").toLowerCase().contains(query))
            .toList();
      });
    }
  }

  // Filter Selected Group Contacts
  List<PersonModel> filterSelectedGroupContacts(
      String group, List<PersonModel> contacts) {
    if (group == "All groups") {
      return contacts;
    }
    // Filter contacts by group
    var filteredContacts = contacts
        .where((element) =>
            element.groups?.any((element) => element.name == group) ?? false)
        .toList();
    if (filteredContacts.length == 0) logger.f("No contacts found");
    return filteredContacts;
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  // Get All Students
  _getAllStudents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Get Groups
  _getGroups() {
    context.read<GroupsBloc>().add(const GroupsEventGetGroups());
  }

  // Refresh Tokens
  void _refreshTokens() {
    var prefs = sl<SharedPreferenceModule>();
    TokenResponse? token = prefs.getToken();
    if (token != null) {
      context.read<AuthBloc>().add(
            AuthEventRefresh(
              RefreshRequest(refresh: token.refreshToken),
            ),
          );
    }
  }

  // Handle Person State Change
  _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      // Clear the existing students list before adding new students
      _getGroups();
      setState(() {
        people.clear();
      });
      // Handle Success
      // for (var person in state.persons) {
      //   if (person.role == Role.Student.name) {
      //     if (!people.contains(person)) {
      //       people.add(person);
      //     } else {
      //       people.remove(person);
      //     }
      //   }
      // }
      setState(() {
        people.addAll(state.persons);
      });
      // var offlineStudentList = json.encode(people);
      // preferences.setString("students", offlineStudentList);
    }
    if (state.status == PersonStatus.error) {
      GFToast.showToast(
        state.errorMessage,
        context,
        toastBorderRadius: 8.0,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
        toastDuration: 6,
      );
    }
  }

  // Handle Group State Change
  _handleGroupStateChange(BuildContext context, GroupsState state) {
    if (state.status == GroupStateStatus.success) {
      // Handle Success
      setState(() {
        roleGroups.clear();
        nonRoleGroups.clear();
        if (state.groups == null) return;
        // groups.add("All groups");
        roleGroups.addAll(state.groups!.where((element) => element.isRole!));
        nonRoleGroups
            .addAll(state.groups!.where((element) => !element.isRole!));
      });
    }
    if (state.status == GroupStateStatus.error) {
      GFToast.showToast(
        state.errorMessage,
        context,
        toastBorderRadius: 8.0,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
        toastDuration: 6,
      );
    }
  }

  // Handle Refresh State
  _handleRefreshState(BuildContext context, AuthState state) {
    if (logout) {
      return;
    }
    if (state.status == AuthStateStatus.authenticated) {
      // Handle Success
      return _getAllStudents();
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      logger.e(state.refreshFailure);
      if (state.refreshFailure != null &&
              state.refreshFailure == "Invalid refresh token." ||
          state.refreshFailure == "Exception: Invalid refresh token.") {
        setState(() {
          logout = true;
        });
        return _logout();
      } else {
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getAllStudents();
    super.initState();
  }

  void updateSelectionState() {
    setState(() {
      isSelect = !isSelect;
      selectedPeople.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the AlphabetListViewOptions
    final AlphabetListViewOptions options =
        _buildAlphabetListViewOptions(updateSelectionState);
    List<String> firstCharacters = getFirstCharacters(people);
    List<String> searchResultsFirstCharacters =
        getFirstCharacters(searchResults);

    personAlphabetView = buildAlphabetView(firstCharacters, people);
    searchResultAlphabetView =
        buildAlphabetView(searchResultsFirstCharacters, searchResults);

    searchController.addListener(() {
      updateSearchResults();
    });

    return VisibilityDetector(
      key: const Key("people_list_invoice"),
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          if (visibilityInfo.visibleFraction == 1.0) {
            setState(() {
              isCurrentPage = true;
            });
          } else {
            setState(() {
              isCurrentPage = false;
            });
          }
        }
      },
      child: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {
          // TODO: implement listener
          if (isCurrentPage && mounted) {
            _handlePersonStateChange(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: BackgroundColors.bgPurple,
            appBar: _buildAppBar(),
            floatingActionButton:
                isSelect ? _buildFloatingActionButton() : Container(),
            body: _buildBody(options, state),
          );
        },
      ),
    );
  }

  // Get First Characters
  List<String> getFirstCharacters(List<PersonModel> contacts) {
    // Group filtered Contacts
    var filteredContacts = filterSelectedGroupContacts(selectedGroup, contacts);
    logger.i(filteredContacts.map((e) => e.firstName).toList());
    return filteredContacts.map((contact) {
      // return contact.firstName.substring(0, 1);

      return contact.firstName.isNotEmpty
          ? contact.firstName.substring(0, 1)
          : "#";
    }).toList();
  }

  List<AlphabetListViewItemGroup> buildAlphabetView(
      List<String> firstCharacters, List<PersonModel> contact) {
        var filteredContacts = filterSelectedGroupContacts(selectedGroup, contact);
    return firstCharacters.map(
      (alphabet) {
        // Include student name starting with number or special character
        filteredContacts.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
          tag: alphabet,
          children: buildStudentListTiles(alphabet, filteredContacts),
        );
      },
    ).toList();
  }

  List<Widget> buildStudentListTiles(
      String alphabet, List<PersonModel> students) {
    return students.map((student) {
      if (student.firstName.startsWith(alphabet)) {
        return buildStudentTile(student);
      }
      return Container();
    }).toList();
  }

  Widget buildStudentTile(PersonModel person) {
    return Column(
      children: [
        ListTile(
          onTap: !isSelect
              ? () {
                  onPersonTileTap(person);
                }
              : null,
          title: Text(
            [
              person.firstName,
              person.middleName ?? "",
              person.lastName1,
              person.lastName2 ?? ""
            ].join(" "),
            style: TextStyle(
                fontSize: CustomFontSize.small,
                color: SecondaryColors.secondaryPurple),
          ),
          trailing: isSelect
              ? Checkbox(
                  activeColor: LightInvoiceColors.dark,
                  value: selectedPeople.contains(person),
                  onChanged: (value) {
                    if (person.childRelations != null &&
                        person.childRelations!.isNotEmpty) {
                      _onSelected(value!, person);
                    } else {
                      GFToast.showToast("No assigned relative", context,
                          toastPosition: GFToastPosition.BOTTOM,
                          toastBorderRadius: 12.0,
                          toastDuration: 6,
                          backgroundColor: Colors.red);
                    }
                  },
                )
              : const SizedBox(),
        ),
        Divider(
          color: SecondaryColors.secondaryPurple.withOpacity(0.2),
        ),
      ],
    );
  }

  void onPersonTileTap(PersonModel student) {
    if (!isSelect) {
      try {
        if (student.childRelations == null || student.childRelations!.isEmpty) {
          GFToast.showToast("No assigned relative", context,
              toastPosition: GFToastPosition.BOTTOM,
              toastBorderRadius: 12.0,
              toastDuration: 6,
              backgroundColor: Colors.red);
          return;
        }
        nextScreen(
            context: context,
            screen: InvoiceDetails(
              key: Key("invoice_details_${student.id}"),
              invoiceType: InvoiceType.CREATE,
              person: student,
            ));
      } catch (e) {
        logger.e(e);
      }
    }
  }

  void updateSearchResults() {
    if (searchController.text.isNotEmpty) {
      searchResults.clear();
      for (var person in people) {
        if (person.firstName.toLowerCase().contains(searchController.text)) {
          searchResults.add(person);
        }
      }
    } else {
      searchResults.clear();
      searchResults.addAll(people);
    }
  }

  AlphabetListViewOptions _buildAlphabetListViewOptions(
      Function updateSelectionState) {
    return AlphabetListViewOptions(
      listOptions: _buildListOptions(updateSelectionState),
      scrollbarOptions: _buildScrollbarOptions(),
      overlayOptions: _buildOverlayOptions(),
    );
  }

  ListOptions _buildListOptions(Function updateSelectionState) {
    return ListOptions(
      beforeList: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            updateSelectionState();
          },
          child: Text(isSelect ? "Single selection" : "Batch creation",
              style: TextStyle(
                  color: Color(0xFF00ADEF),
                  fontSize: CustomFontSize.extraSmall)),
        ),
      ),
      listHeaderBuilder: (context, symbol) => _buildListHeader(symbol),
    );
  }

  Widget _buildListHeader(String symbol) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: PrimaryColors.primaryPurple,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(symbol,
                  style: TextStyle(
                      color: SecondaryColors.secondaryPurple,
                      fontSize: CustomFontSize.small)),
            ),
          ),
        ),
      ],
    );
  }

  ScrollbarOptions _buildScrollbarOptions() {
    return ScrollbarOptions(
      backgroundColor: BackgroundColors.bgPurple,
    );
  }

  OverlayOptions _buildOverlayOptions() {
    return OverlayOptions(
      showOverlay: true,
      overlayBuilder: (context, symbol) => _buildOverlay(symbol),
    );
  }

  Widget _buildOverlay(String symbol) {
    return Container(
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: SecondaryColors.secondaryPurple.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(symbol,
            style: const TextStyle(
              fontSize: 63,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  // Build AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: PrimaryColors.primaryPurple,
      iconTheme: IconThemeData(
        color: SecondaryColors.secondaryPurple,
      ),
      title: Text(
        isSelect ? "Select recipients" : "Select recipient",
        style: TextStyle(
          color: SecondaryColors.secondaryPurple,
          fontSize: CustomFontSize.large,
        ),
      ),
      centerTitle: true,
      actions: [
        BlocListener<GroupsBloc, GroupsState>(
          listenWhen: (prev, current) => isCurrentPage,
          listener: (context, state) {
            _handleGroupStateChange(context, state);
          },
          child: Container(),
        ),
      ],
      bottom: _buildPreferredSizeWidget(context),
    );
  }

  // Build PreferredSize Widget
  PreferredSizeWidget _buildPreferredSizeWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(160),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [_buildDropDownOptions(context), _buildSearchBar()],
        ),
      ),
    );
  }

  // Build DropDown Options
  Widget _buildDropDownOptions(BuildContext context) {
    return CustomDropDownMenu(
      color: SecondaryColors.secondaryPurple,
      options: [
        "Groups",
        "All groups",
        ...roleGroups.map((group) => group.name).toList(),
      ],
      value: selectedGroup,
      onChanged: _updateGroups,
    );
  }

  // Build Search Bar
  Widget _buildSearchBar() {
    return CustomTextField(
      prefixIcon: Icon(
        Icons.search_rounded,
        color: SecondaryColors.secondaryPurple,
      ),
      hintText: "Search",
      controller: searchController,
      onChanged: search,
      color: SecondaryColors.secondaryPurple,
    );
  }

  // Build Body
  Widget _buildBody(AlphabetListViewOptions options, PersonState state) {
    return state.isLoading && people.isEmpty
        ? const Center(
            child: GFLoader(type: GFLoaderType.ios),
          )
        : errorMsg.isNotEmpty
            ? Center(
                child: Text(
                  errorMsg,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ):
              filterSelectedGroupContacts(selectedGroup, people).isEmpty
                ? Center(
                    child: Text(
                      "No person found",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
            : showResults
                ? searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        items: searchResultAlphabetView,
                        options: options,
                      )
                : people.isEmpty
                    ? Center(
                        child: Text(
                          "No students found",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        options: options,
                        items: personAlphabetView,
                      );
  }

  // Floating Action Button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: LightInvoiceColors.dark,
      onPressed: () {
        if (selectedPeople.isNotEmpty) {
          nextScreen(
            context: context,
            screen: InvoiceDetails(
              key: Key("invoice_details_${selectedPeople[0].id}"),
              invoiceType: InvoiceType.CREATE,
              persons: selectedPeople,
            ),
          );
        }
      },
      label: Text(
        "Next",
        style: TextStyle(
          color: Colors.white,
          fontSize: CustomFontSize.medium,
        ),
      ),
    );
  }
}
