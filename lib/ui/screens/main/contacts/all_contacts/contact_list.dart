import 'dart:math';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../data/constants/logger.dart';
import '../../../../../data/constants/shared_prefs.dart';
import '../../../../../data/person/model/person_model.dart';
import '../../../../utilities/custom_colors.dart';
import '../../../../utilities/font_sizes.dart';
import '../../../../widgets/inputs/drop_down_menu.dart';
import '../../../../widgets/inputs/text_field.dart';
import '../../../auth/group_bloc/groups_bloc.dart';
import '../../person/bloc/person_bloc.dart';
import '../person_details.dart';

var sl = GetIt.instance;

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  bool logout = false;
  TextEditingController searchController = TextEditingController();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  var prefs = sl<SharedPreferenceModule>();
  List<PersonModel> searchResults = [];
  List<PersonModel> contacts = [];
  List<PersonModel> selectedContacts = [];

  // Groups
  List<String> groups = [];
  String selectedGroup = "All groups";
  bool showResults = false;
  String errorMsg = "";
  late List<AlphabetListViewItemGroup> contactAlphabetView;
  late List<AlphabetListViewItemGroup> searchResultAlphabetView;
  bool loading = false;
  Key contactData = const Key("contact-data");
  bool isCurrentPage = false;

  // Search Function
  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        showResults = false;
      });
    } else {
      setState(() {
        showResults = true;
        searchResults = contacts
            .where((element) =>
                element.firstName.toLowerCase().contains(query.toLowerCase()) ||
                (element.middleName ?? "")
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element.lastName1.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  // Update Selected Groups
  void updateSelectedGroup(group) {
    setState(() {
      selectedGroup = group;
    });
  }

  // Filter Selected Group Contacts
  List<PersonModel> filterSelectedGroupContacts(
      String group, List<PersonModel> contacts) {
    if (group == "All groups") {
      return contacts;
    }
    return contacts.where((element) => element.role == group).toList();
  }

  // Create or Update Student
  void createOrUpdateContact({
    required ScreenFunction screenFunction,
    PersonModel? contact,
  }) async {
    PersonModel? contactData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetails(
          screenFunction: screenFunction,
          contactVariant: ContactVariant.others,
          isParent: false,
          person: contact,
        ),
      ),
    );
    if (contactData != null) {
      int idx = contacts.indexWhere((element) => element.id == contactData.id);
      if (contactData.groups?.any((element) => element.name == "Student") ??
          false) {
        if (idx != -1) {
          contacts.removeAt(idx);
        }
      } else {
        if (idx == -1) {
          contacts.add(contactData);
        } else {
          contacts[idx] = contactData;
        }
      }
      setState(() {});
      prefs.saveAllContacts(contacts);
    }
  }

  // Get All Contacts
  void _getAllContacts() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Get All Groups
  void _getAllGroups() {
    context.read<GroupsBloc>().add(const GroupsEventGetGroups());
  }

  // Handle Person State Change
  void _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      // Clear the list of contacts
      contacts.clear();
      // Add the contact to the list
      contacts.addAll(
        state.persons.where(
          (element) => element.role != Role.Student.name,
        ),
      );
      // Save the contacts to the shared preferences
      prefs.saveAllContacts(contacts);
      setState(() {});
    }
    // Handle the error
    if (state.status == PersonStatus.error) {
      // Handle Invalid refresh token
      if (state.errorMessage == "Invalid refresh token") {
        setState(() {
          logout = true;
        });
      }
      GFToast.showToast(
        state.errorMessage,
        context,
        toastDuration: 6,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        toastBorderRadius: 8.0,
      );
    }
  }

  // Handle Group State Change
  void _handleGroupStateChange(BuildContext context, GroupsState state) {
    if (state.status == GroupStateStatus.success) {
      // Clear the list of groups
      groups.clear();
      // Add the groups to the list
      groups.addAll(state.groups!
          .where((element) => element.isRole! && element.name != "Student")
          .map((e) => e.name!));
      // Save the groups to the shared preferences
      prefs.saveGroups(state.groups!);
    }
    // Handle the error
    if (state.status == GroupStateStatus.error) {
      GFToast.showToast(
        state.errorMessage,
        context,
        toastDuration: 6,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        toastBorderRadius: 8.0,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // Get All contacts from Shared Preferences
    var contactsFromSharedPrefs = prefs.getAllContacts();
    contacts.addAll(contactsFromSharedPrefs);

    // Get All Groups from Shared Preferences
    var groupsFromSharedPrefs = prefs.getGroups();
    groups.addAll(groupsFromSharedPrefs
        .where((element) => element.isRole! && element.name != "Student")
        .map((e) => e.name!));

    _getAllContacts();
    _getAllGroups();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    isCurrentPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the alphabet view
    contactAlphabetView = buildAlphabetView(
      getFirstCharacters(contacts),
      contacts,
    );

    // Initialize the search result alphabet view
    searchResultAlphabetView = buildAlphabetView(
      getFirstCharacters(searchResults),
      searchResults,
    );

    // Initialize the alphabet list view options
    var options = _buildAlphabetListViewOptions();

    return VisibilityDetector(
      key: contactData,
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          setState(() {
            isCurrentPage = true;
          });
        } else {
          if (mounted) {
            setState(() {
              isCurrentPage = false;
            });
          }
        }
      },
      child: BlocConsumer<PersonBloc, PersonState>(
        listenWhen: (prev, current) => isCurrentPage,
        listener: (context, state) {
          _handlePersonStateChange(context, state);
        },
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.green.shade50,
          appBar: _buildAppBar(options),
          body: _buildBody(options, state),
        ),
      ),
    );
  }

  // Get First Characters
  List<String> getFirstCharacters(List<PersonModel> contacts) {
    // Group filtered Contacts
    var filteredContacts = filterSelectedGroupContacts(selectedGroup, contacts);
    return filteredContacts.map((contact) {
      logger.wtf(contact.firstName);
      // return contact.firstName?.substring(0, 1) ?? "";

      return contact.firstName.isNotEmpty
          ? contact.firstName.substring(0, 1)
          : "";
    }).toList();
  }

  // Build Alphabet View
  List<AlphabetListViewItemGroup> buildAlphabetView(
    List<String> firstCharacters,
    List<PersonModel> contacts,
  ) {
    final firstCharactersSet = firstCharacters.toSet();

    firstCharactersSet
        .removeWhere((element) => (!RegExp(r'[a-zA-Z]').hasMatch(element)));

    firstCharactersSet.add('#');

    return firstCharactersSet.map(
      (alphabet) {
        selectedGroupPeople() {
          if (selectedGroup == groups[0]) {
            // contacts in initial group
          }
        }

        // final fcContacts = contacts
        //     .where((element) => element.firstName.startsWith(alphabet))
        //     .toList();
        final fcContacts = contacts.where(
          (element) {
            if (alphabet == '#' &&
                !RegExp(r'[a-zA-Z]').hasMatch(element.firstName[0])) {
              return true;
            } else {
              return element.firstName.startsWith(alphabet);
            }
          },
        ).toList();

        fcContacts.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
          tag: alphabet,
          children: fcContacts.map(
            (contact) {
              return buildStudentTile(
                contact,
              );
            },
          ),
        );
      },
    ).toList();
  }

  // Build Contact List Tiles
  List<Widget> buildStudentListTiles(
    String alphabet,
    List<PersonModel> contacts,
  ) {
    return contacts.map((contact) {
      if (contact.firstName.startsWith(alphabet)) {
        return buildStudentTile(
          contact,
        );
      }
      return Container();
    }).toList();
  }

  // Build Contact Tile
  Widget buildStudentTile(
    PersonModel contact,
  ) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onStudentTileTap(contact);
          },
          title: Text(
            [
              contact.firstName ?? "First Name",
              contact.middleName ?? "",
              contact.lastName1 ?? "Last Name",
              contact.lastName2 ?? ""
            ].join(" ").trim(),
            style: TextStyle(
                fontSize: CustomFontSize.small,
                color: SecondaryColors.secondaryLightGreen),
          ),
        ),
        Divider(
          color: SecondaryColors.secondaryLightGreen.withOpacity(0.2),
        ),
      ],
    );
  }

  // On Contact Tile Tap
  void onStudentTileTap(PersonModel contact) => createOrUpdateContact(
        screenFunction: ScreenFunction.edit,
        contact: contact,
      );

  // Update Search Results
  void updateSearchResults() {
    if (searchController.text.isNotEmpty) {
      searchResults.clear();
      for (var contact in contacts) {
        if (contact.firstName.toLowerCase().contains(searchController.text)) {
          searchResults.add(contact);
        }
      }
    } else {
      searchResults.clear();
      searchResults.addAll(contacts);
    }
  }

  // Build Alphabet View Options
  AlphabetListViewOptions _buildAlphabetListViewOptions() {
    return AlphabetListViewOptions(
      listOptions: _buildListOptions(),
      scrollbarOptions: _buildScrollbarOptions(),
      overlayOptions: _buildOverlayOptions(),
    );
  }

  // Build List Options
  ListOptions _buildListOptions() {
    return ListOptions(
      listHeaderBuilder: (context, symbol) => _buildListHeader(symbol),
    );
  }

  // Build List Header
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
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(symbol,
                  style: TextStyle(
                      color: SecondaryColors.secondaryLightGreen,
                      fontSize: CustomFontSize.small)),
            ),
          ),
        ),
      ],
    );
  }

  // Build Scrollbar Options
  ScrollbarOptions _buildScrollbarOptions() {
    return ScrollbarOptions(
      backgroundColor: Colors.green.shade50,
    );
  }

  // Build Overlay Options
  OverlayOptions _buildOverlayOptions() {
    return OverlayOptions(
      showOverlay: true,
      overlayBuilder: (context, symbol) => _buildOverlayWidget(symbol),
    );
  }

  // Build Overlay Widget
  Widget _buildOverlayWidget(String symbol) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              color: SecondaryColors.secondaryLightGreen,
              fontSize: 63,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Build App Bar
  AppBar _buildAppBar(AlphabetListViewOptions options) {
    return AppBar(
      iconTheme: IconThemeData(color: SecondaryColors.secondaryLightGreen),
      backgroundColor: Colors.green.shade100,
      title: Text(
        "Manage contacts",
        style: TextStyle(
          color: SecondaryColors.secondaryLightGreen,
        ),
      ),
      centerTitle: true,
      actions: [
        // Group Bloc Listener
        BlocListener<GroupsBloc, GroupsState>(
          listener: (context, state) {
            _handleGroupStateChange(context, state);
          },
          child: Container(),
        ),
        // Auth Bloc Listener
        // BlocListener<PersonBloc, PersonState>(
        //   listener: (context, state) {
        //     _handlePersonStateChange(context, state);
        //   },
        //   child: Container(),
        // ),
        IconButton(
          onPressed: () => createOrUpdateContact(
            screenFunction: ScreenFunction.add,
          ),
          icon: const Icon(
            Icons.add_rounded,
            size: 28,
          ),
        ),
      ],
      bottom: _buildPreferredSize(),
    );
  }

  // Build Preferred Size
  PreferredSize _buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 170),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // Contact Groups
            CustomDropDownMenu(
              color: SecondaryColors.secondaryLightGreen,
              options: [
                "Select group",
                "All groups",
                ...groups,
              ],
              value: selectedGroup,
              onChanged: updateSelectedGroup,
            ),
            CustomTextField(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: SecondaryColors.secondaryLightGreen,
              ),
              color: SecondaryColors.secondaryLightGreen,
              hintText: "Search...",
              controller: searchController,
              onChanged: search,
            ),
          ],
        ),
      ),
    );
  }

  // Build Body
  Widget _buildBody(AlphabetListViewOptions options, PersonState state) {
    return state.isLoading && contacts.isEmpty
        ? const Center(
            child: GFLoader(
              type: GFLoaderType.ios,
            ),
          )
        : errorMsg.isNotEmpty
            ? Center(
                child: Text(
                  "errorMsg",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            : showResults
                ? searchResults.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: CustomFontSize.medium,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        items: searchResultAlphabetView,
                        options: options,
                      )
                : contacts.isEmpty
                    ? const Center(
                        child: Text(
                          "No contact found",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        options: options,
                        items: contactAlphabetView,
                      );
  }

  // Build Bottom Navigation Bar
  Widget _buildBottomNavigationBar(bool isSelect) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: CustomColor.grey.withOpacity(0.5),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomNavigationBarText(),
              // _buildFloatingActionButton(isSelect),
            ],
          ),
        ),
      ],
    );
  }

  // Build Bottom Navigation Bar Text
  Widget _buildBottomNavigationBarText() {
    return Text(
      "Select contacts",
      style: TextStyle(
        color: SecondaryColors.secondaryLightGreen,
        fontSize: CustomFontSize.medium,
      ),
    );
  }

//

//
}
