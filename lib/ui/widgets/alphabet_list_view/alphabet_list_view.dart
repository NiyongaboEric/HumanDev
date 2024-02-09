import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';

import '../../../data/constants/logger.dart';
import '../../../data/person/model/person_model.dart';
import '../../screens/main/contacts/person_details.dart';
import '../../utilities/colors.dart';
import '../../utilities/font_sizes.dart';

class AlphabetListViewConstants {
  // Get First Characters
  List<String> getFirstCharacters(List<PersonModel> students) {
    return students.map((student) {
      return student.firstName.substring(0, 1);
    }).toList();
  }

  // Build Alphabet View
  List<AlphabetListViewItemGroup> buildAlphabetView(
      BuildContext context,
      List<String> firstCharacters, List<PersonModel> students) {
    return firstCharacters.map(
      (alphabet) {
        students.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
          tag: alphabet,
          children: buildStudentListTiles(context, alphabet, students),
        );
      },
    ).toList();
  }

  // Build Student List Tiles
  List<Widget> buildStudentListTiles(
      BuildContext context,
      String alphabet, List<PersonModel> students) {
    return students.map((student) {
      if (student.firstName.startsWith(alphabet)) {
        return buildStudentTile(context, student);
      }
      return Container();
    }).toList();
  }

  // Build Student Tile
  Widget buildStudentTile(
    BuildContext context,
    PersonModel student,
  ) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onStudentTileTap(context, student, () {});
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
                color: SecondaryColors.secondaryPink),
          ),
        ),
        Divider(
          color: SecondaryColors.secondaryPink.withOpacity(0.2),
        ),
      ],
    );
  }

  // On Student Tile Tap
  void onStudentTileTap(BuildContext context, PersonModel student, Function getAllContacts) async {
    bool? refresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetails(
          screenFunction: ScreenFunction.edit,
          contactVariant: ContactVariant.student,
          person: student,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    logger.d("Update Refresh: $refresh");
    if (refresh != null && refresh) {
      getAllContacts();
    }
  }
}
