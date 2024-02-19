import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/sms_reminder/send_sms.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../../data/constants/logger.dart';
import '../../../../../../data/constants/shared_prefs.dart';
import '../../../../../../data/person/model/person_model.dart';
import '../../../../../../data/reminders/model/reminder_request.dart';
import '../../../../../utilities/custom_colors.dart';
import '../../../../../utilities/font_sizes.dart';
import '../../../../../utilities/navigation.dart';
import '../../../../../widgets/inputs/text_field.dart';
import '../../../person/bloc/person_bloc.dart';
import '../../blocs/reminder_bloc.dart';

var sl = GetIt.instance;

class SMSReminderStudentListScreen extends StatefulWidget {
  const SMSReminderStudentListScreen({super.key});

  @override
  State<SMSReminderStudentListScreen> createState() =>
      _SMSReminderStudentListScreenState();
}

class _SMSReminderStudentListScreenState
    extends State<SMSReminderStudentListScreen> {
  bool logout = false;
  TextEditingController searchController = TextEditingController();
  var prefs = sl<SharedPreferenceModule>();
  List<PersonModel> searchResults = [];
  List<PersonModel> students = [];
  List<PersonModel> selectedStudents = [];
  List<ChildRelation> selectedParents = <ChildRelation>[];
  // Groups
  List<String> groups = [];
  String selectedGroup = "Student";
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
      logger.wtf(query);
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

  void addParent(ChildRelation parents) {
    setState(() {
      selectedParents.add(parents);
    });
  }

  void removeParent(ChildRelation parents) {
    setState(() {
      selectedParents.remove(parents);
    });
  }

  void addStudent(PersonModel student) {
    setState(() {
      selectedStudents.add(student);
    });
  }

  void removeStudent(PersonModel student) {
    setState(() {
      selectedStudents.remove(student);
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

  // Save Data
  saveData() {
    List<ReminderRequest> reminderRequests = selectedParents.map((parent) {
      return ReminderRequest(
        type: ReminderType.SENT_SMS,
        relativePersonId: parent.id,
        studentPersonId: students
            .firstWhere(
              (student) => student.childRelations!.any(
                (relative) => relative.id == parent.id,
              ),
            )
            .id,
        fullName: "${parent.firstName} ${parent.lastName1}",
        phoneNumber: parent.phoneNumber1,
      );
    }).toList();

    for (var element in reminderRequests) {
      logger.d(element.fullName);
      logger.d(element.phoneNumber);
    }

    List<String> recipients =
        selectedParents.map((e) => "${e.firstName} ${e.lastName1}").toList();

    context.read<ReminderBloc>().add(
          SaveDataReminderState(
            reminderRequests,
            recipients,
          ),
        );
  }

  // Get All Students
  void _getAllStudents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Handle Person State Change
  void _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      // Clear the list of students
      students.clear();
      // Add the students to the list
      students.addAll(
        state.persons.where(
          (element) =>
              element.role == Role.Student.name &&
              (element.studentInvoices != null &&
                  element.studentInvoices!.isNotEmpty),
        ),
      );
      // Save the students to the shared preferences
      prefs.saveStudents(state.persons
          .where((element) => element.role == Role.Student.name)
          .toList());

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

  // Handle Reminder State Change
  _handleReminderStateChange(BuildContext context, ReminderState state) {
    if (state.status == ReminderStateStatus.success) {
      navigate(context);
    }

    if (state.status == ReminderStateStatus.error) {
      logger.d(state.errorMessage ?? "Error");
    }
  }

  void navigate(BuildContext context) {
    List<PersonModel> studentsWithoutParentNumber =
        findStudentsWithoutParentNumber();

    if (studentsWithoutParentNumber.isNotEmpty) {
      showPhoneNumberErrorDialog(context, studentsWithoutParentNumber);
    } else {
      nextScreen(context: context, screen: SendSMS());
    }
  }

  List<PersonModel> findStudentsWithoutParentNumber() {
    List<PersonModel> result = [];

    return result;
  }

  void showPhoneNumberErrorDialog(
      BuildContext context, List<PersonModel> studentsWithoutParentNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.orange.shade50,
        icon: const Icon(
          Icons.info_rounded,
          color: Colors.red,
          size: 56,
        ),
        content: Text(
          "No phone number found for parents of: \n ${studentsWithoutParentNumber.map((element) {
            return "${element.firstName}${element.middleName != null && element.middleName!.isNotEmpty ? ' ' : ''}${element.middleName ?? ''} ${element.lastName1}";
          }).join(", ")}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CustomFontSize.medium,
            color: SecondaryColors.secondaryOrange,
          ),
        ),
        actions: [
          SizedBox(
            width: 100,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange.shade100,
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text(
                "OK",
                style: TextStyle(
                  fontSize: CustomFontSize.medium,
                  color: SecondaryColors.secondaryOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // Get All Students from Shared Preferences
    var studentsFromSharedPrefs = prefs.getStudents();
    students.addAll(studentsFromSharedPrefs.where((element) =>
        (element.studentInvoices != null &&
            element.studentInvoices!.isNotEmpty)));

    _getAllStudents();
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
          // extendBodyBehindAppBar: true,
          // extendBody: true,
          backgroundColor: Colors.orange.shade50,
          floatingActionButton:
              students.isNotEmpty ? _buildFloatingActionButton() : null,
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
      return contact.firstName.isNotEmpty
          ? contact.firstName.substring(0, 1)
          : "";
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
    // Student Full Name using join method
    var fullName = [
      student.firstName,
      student.middleName ?? "",
      student.lastName1,
    ].join(" ");
    return Column(
      children: [
        ListTile(
          title: _buildTitleRow(fullName, student),
          subtitle: _buildSubtitleRow(student),
          trailing: _buildCheckbox(student),
        ),
        Divider(
          color: SecondaryColors.secondaryOrange.withOpacity(0.2),
        ),
      ],
    );
  }

  // Build Title Row
  Row _buildTitleRow(String fullName, PersonModel person) => Row(
        children: [
          Text(
            fullName.length > 24 ? '${fullName.substring(0, 11)}...' : fullName,
            style: TextStyle(
                color: SecondaryColors.secondaryOrange,
                fontSize: CustomFontSize.small),
          ),
          const SizedBox(width: 10),
          _buildNullNumberImage(person),
        ],
      );

  // Build Null Number Image
  Widget _buildNullNumberImage(PersonModel person) {
    if (person.childRelations == null ||
        person.childRelations!.isEmpty ||
        person.childRelations!.any((element) =>
                (element.phoneNumber1 == null && element.phoneNumber1!.isEmpty)
            // (element.phoneNumber2 == null && element.phoneNumber2!.isEmpty) ||
            // (element.phoneNumber3 == null && element.phoneNumber3!.isEmpty)
            )) {
      return Image.asset("assets/icons/null_number.png",
          width: 20, height: 20, color: Colors.red);
    } else {
      return const SizedBox();
    }
  }

  // Build Subtitle Row
  Row? _buildSubtitleRow(PersonModel person) => Row(children: [
        _buildSubtitleText(person),
        _buildNullNumberImageForSubtitle(person)
      ]);

  // Build Subtitle Text
  Widget _buildSubtitleText(PersonModel person) => Expanded(
        child: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            "${DateFormat('dd MMM yy').format(DateTime.parse(person.studentInvoices!.first.invoiceDate))} - Due: ${person.studentInvoices!.first.currency} ${person.totalDue}",
            style: TextStyle(
                fontSize: CustomFontSize.small,
                color: SecondaryColors.secondaryOrange),
          ),
        ),
      );
  // Build Null Number Image For Subtitle
  Widget _buildNullNumberImageForSubtitle(PersonModel person) =>
      (person.childRelations == null ||
              person.childRelations!.isEmpty ||
              person.childRelations!.any((element) =>
                  element.phoneNumber1 != null &&
                      element.phoneNumber1!.isNotEmpty ||
                  element.phoneNumber2 != null &&
                      element.phoneNumber2!.isNotEmpty ||
                  element.phoneNumber3 != null &&
                      element.phoneNumber3!.isNotEmpty))
          ? const SizedBox.shrink()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                Image.asset("assets/icons/null_number.png",
                    width: 25, height: 25, color: Colors.red),
              ],
            );

  // Build Checkbox
  Widget? _buildCheckbox(PersonModel person) => SizedBox.square(
        dimension: 25,
        child: Checkbox(
          activeColor: SecondaryColors.secondaryOrange,
          value: getCheckboxValue(person),
          onChanged: (value) => onCheckboxChanged(person, value),
        ),
      );
  // On Checkbox Changed
  onCheckboxChanged(PersonModel person, bool? value) {
    if (person.childRelations != null) {
      if (value!) {
        // Iterate over child relations and add parents
        person.childRelations!
            .where((relatedPerson) =>
                relatedPerson.phoneNumber1 != null &&
                    relatedPerson.phoneNumber1!.isNotEmpty ||
                relatedPerson.phoneNumber2 != null &&
                    relatedPerson.phoneNumber2!.isNotEmpty ||
                relatedPerson.phoneNumber3 != null &&
                    relatedPerson.phoneNumber3!.isNotEmpty)
            .forEach(addParent);

        // Add Student if parent is selected
        for (var element in selectedParents) {
          if (person.childRelations!.contains(element)) {
            addStudent(person);
          }
        }
      } else {
        // Iterate over child relations and remove parents
        person.childRelations!
            .where((relatedPerson) =>
                relatedPerson.phoneNumber1 != null &&
                    relatedPerson.phoneNumber1!.isNotEmpty ||
                relatedPerson.phoneNumber2 != null &&
                    relatedPerson.phoneNumber2!.isNotEmpty ||
                relatedPerson.phoneNumber3 != null &&
                    relatedPerson.phoneNumber3!.isNotEmpty)
            .forEach(removeParent);

        // Remove Student if parent is unselected
        for (var element in selectedParents) {
          if (!person.childRelations!.contains(element)) {
            removeStudent(person);
          }
        }
      }
    }

    // Check if no phone number found for parent
    if (person.childRelations == null ||
        person.childRelations!.every((element) =>
            element.phoneNumber1 == null &&
            element.phoneNumber2 == null &&
            element.phoneNumber3 == null)) {
      GFToast.showToast(
        "No phone number found for parent",
        context,
        toastPosition: GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
        toastBorderRadius: 12.0,
        toastDuration: 5,
      );
    }
  }

  // Get Checkbox Value
  bool getCheckboxValue(PersonModel person) =>
      selectedParents.any((selectedParent) =>
          person.childRelations?.contains(selectedParent) ?? false);

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
              color: Colors.orange.shade200,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(symbol,
                  style: TextStyle(
                      color: SecondaryColors.secondaryOrange,
                      fontSize: CustomFontSize.small)),
            ),
          ),
        ),
      ],
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
          color: Colors.orange.shade300.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              color: SecondaryColors.secondaryOrange,
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
      iconTheme: IconThemeData(color: SecondaryColors.secondaryOrange),
      backgroundColor: Colors.orange.shade100,
      title: Text(
        "Select students",
        style: TextStyle(
          color: SecondaryColors.secondaryOrange,
        ),
      ),
      centerTitle: true,
      actions: [_buildReminderBlocListener()],
      bottom: students.isNotEmpty? _buildPreferredSize(): null,
    );
  }

  Widget _buildReminderBlocListener() {
    return BlocListener<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (isCurrentPage) {
          _handleReminderStateChange(context, state);
        }
      },
      child: Container(),
    );
  }

  // Build Floating Action Button
  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: selectedParents.isEmpty
          ? Colors.grey.shade300
          : Colors.orange.shade100,
      onPressed: selectedParents.isEmpty
          ? null
          : () {
              saveData();
            },
      label: SizedBox(
        width: 80,
        child: Center(
          child: Text(
            "Next",
            style: TextStyle(
                fontSize: CustomFontSize.large,
                color: selectedParents.isEmpty
                    ? Colors.grey
                    : SecondaryColors.secondaryOrange),
          ),
        ),
      ),
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
            CustomTextField(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: SecondaryColors.secondaryOrange,
              ),
              color: SecondaryColors.secondaryOrange,
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
                            color: SecondaryColors.secondaryOrange,
                            fontSize: CustomFontSize.medium,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        items: searchResultAlphabetView,
                        options: options,
                      )
                : students.isEmpty
                    ? Center(
                        child: Text(
                          "There are no students behind payments schedules.",
                          // Center text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: SecondaryColors.secondaryOrange,
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
