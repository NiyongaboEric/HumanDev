import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/recieved_money/tuition_fee/tuition_fee_record.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../../data/constants/logger.dart';
import '../../../../../../data/constants/shared_prefs.dart';
import '../../../../../../data/person/model/person_model.dart';
import '../../../../../utilities/font_sizes.dart';
import '../../../../../widgets/inputs/drop_down_menu.dart';
import '../../../../../widgets/inputs/text_field.dart';
import '../../../../auth/group_bloc/groups_bloc.dart';
import '../../../contacts/person_details.dart';
import '../../../person/bloc/person_bloc.dart';



var sl = GetIt.instance;

class TuitionFeeStudentListScreen extends StatefulWidget {
  const TuitionFeeStudentListScreen({super.key});

  @override
  State<TuitionFeeStudentListScreen> createState() =>
      _TuitionFeeStudentListScreenState();
}

class _TuitionFeeStudentListScreenState extends State<TuitionFeeStudentListScreen> {
  bool logout = false;
  TextEditingController searchController = TextEditingController();
  // ConnectivityResult _connectivityResult = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  var prefs = sl<SharedPreferenceModule>();
  List<PersonModel> searchResults = [];
  List<PersonModel> students = [];
  List<PersonModel> selectedStudents = [];
  // Groups
  List<String> groups = [];
  String selectedGroup = "All groups";
  bool showResults = false;
  String errorMsg = "";
  late List<AlphabetListViewItemGroup> studentAlphabetView;
  late List<AlphabetListViewItemGroup> searchResultAlphabetView;
  bool loading = false;
  Key studentData = const Key("student-data");
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
        searchResults = students
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

  // Get All Students
  void _getAllStudents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Get All Groups
  void _getAllGroups() {
    context.read<GroupsBloc>().add(const GroupsEventGetGroups());
  }

  // Handle Person State Change
  void _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      // Clear the list of students
      students.clear();
      // Add the students to the list
      students.addAll(
        state.persons.where(
          (element) => element.role == Role.Student.name,
        ),
      );
      // Save the students to the shared preferences
      prefs.saveStudents(students);

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
          .where((element) => element.isRole!)
          .map((e) => e.name!));
      logger.wtf(groups);
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
    // Get All Students from Shared Preferences
    // var studentsFromSharedPrefs = prefs.getStudents();
    // students.addAll(studentsFromSharedPrefs);

    // Get All Groups from Shared Preferences
    var groupsFromSharedPrefs = prefs.getGroups();
    groups.addAll(groupsFromSharedPrefs
        .where((element) => element.isRole!)
        .map((e) => e.name!));
    _getAllStudents();
    _getAllGroups();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the alphabet view
    studentAlphabetView = buildAlphabetView(
      getFirstCharacters(students),
      students,
    );

    // Initialize the search result alphabet view
    searchResultAlphabetView = buildAlphabetView(
      getFirstCharacters(searchResults),
      searchResults,
    );

    // Initialize the alphabet list view options
    var options = _buildAlphabetListViewOptions();

    return VisibilityDetector(
      key: studentData,
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          setState(() {
            isCurrentPage = true;
          });
        } else {
          if (isCurrentPage) {
            isCurrentPage = false;
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
  List<String> getFirstCharacters(List<PersonModel> students) {
    return students.map((student) {
      return student.firstName.substring(0, 1);
    }).toList();
  }

  // Build Alphabet View
  List<AlphabetListViewItemGroup> buildAlphabetView(
      List<String> firstCharacters, List<PersonModel> students) {
    return firstCharacters.map(
      (alphabet) {
        selectedGroupPeople() {
          if (selectedGroup == groups[0]) {
            // Students in initial group
          }
        }

        students.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
          tag: alphabet,
          children: buildStudentListTiles(
            alphabet,
            students,
          ),
        );
      },
    ).toList();
  }

  // Build Student List Tiles
  List<Widget> buildStudentListTiles(
      String alphabet, List<PersonModel> students) {
    return students.map((student) {
      if (student.firstName.startsWith(alphabet)) {
        return buildStudentTile(
          student,
        );
      }
      return Container();
    }).toList();
  }

  // Build Student Tile
  Widget buildStudentTile(
    PersonModel student,
  ) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onStudentTileTap(student);
          },
          title: Text(
            [
              student.firstName ?? "First Name",
              student.middleName ?? "",
              student.lastName1 ?? "Last Name",
              student.lastName2 ?? ""
            ].join(" ").trim(),
            style: TextStyle(
                fontSize: CustomFontSize.small,
                color: SecondaryColors.secondaryGreen),
          ),
        ),
        Divider(
          color: SecondaryColors.secondaryGreen.withOpacity(0.2),
        ),
      ],
    );
  }

  // On Student Tile Tap
  void onStudentTileTap(PersonModel student) async {
    bool? refresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TuitionFeeRecord(student: student),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    logger.d("Update Refresh: $refresh");
    if (refresh != null && refresh) {
      _getAllStudents();
    }
  }

  // Update Search Results
  void updateSearchResults() {
    if (searchController.text.isNotEmpty) {
      searchResults.clear();
      for (var student in students) {
        if (student.firstName.toLowerCase().contains(searchController.text)) {
          searchResults.add(student);
        }
      }
    } else {
      searchResults.clear();
      searchResults.addAll(students);
    }
  }

  // Build Alphabet View Options
  AlphabetListViewOptions _buildAlphabetListViewOptions() {
    return AlphabetListViewOptions(
      listOptions: _buildListOptions(),
      // scrollbarOptions: _buildScrollbarOptions(),
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
                      color: SecondaryColors.secondaryGreen,
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
        // backgroundColor: Colors.green.shade50,
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
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.green.shade300.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              color: SecondaryColors.secondaryGreen,
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
      iconTheme: IconThemeData(color: SecondaryColors.secondaryGreen),
      backgroundColor: Colors.green.shade100,
      title: Text(
        "Select student",
        style: TextStyle(
          color: SecondaryColors.secondaryGreen,
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
      ],
      bottom: _buildPreferredSize(),
    );
  }

  // Build Preferred Size
  PreferredSize _buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // Searach Bar
            CustomTextField(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: SecondaryColors.secondaryGreen,
              ),
              color: SecondaryColors.secondaryGreen,
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
    return state.isLoading && students.isEmpty
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
                            color: SecondaryColors.secondaryGreen,
                            fontSize: CustomFontSize.medium,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        items: searchResultAlphabetView,
                        options: options,
                      )
                : students.isEmpty
                    ? const Center(
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
                        items: studentAlphabetView,
                      );
  }
}
