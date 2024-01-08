import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';

class GroupDropdownMenu extends StatelessWidget {
  GroupDropdownMenu({
    super.key, 
    required this.groupSpace, 
    required this.handleChangeDropdownItem,
    required this.btnstyle,
    required this.inputDecorationTheme,
    required this.leadingIcon,
  });

  List<Group> groupSpace;
  Function(dynamic) handleChangeDropdownItem;
  ButtonStyle btnstyle;
  InputDecorationTheme inputDecorationTheme;
  Icon leadingIcon;
  
  @override
  Widget build(BuildContext context) {

    DropdownMenu dropdownMenu;

    if (groupSpace.isEmpty) {
      List<String> data = ['No groups available'];
      dropdownMenu = DropdownMenu<String>(
        menuStyle: MenuStyle(
          backgroundColor: 
            MaterialStatePropertyAll<Color>(BackgroundColors.bgBlue),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
        ),
        leadingIcon: leadingIcon,
        inputDecorationTheme: inputDecorationTheme,
        width: 390,
        initialSelection: data.first,
        onSelected: (String? value) => handleChangeDropdownItem(value),  
        dropdownMenuEntries: data.map<DropdownMenuEntry<String>>((item) {
          return DropdownMenuEntry<String>(
            value: item, 
            label: item,
            style: btnstyle
          );
        }).toList(),
      );
    } else {
      dropdownMenu = DropdownMenu<String>(
        menuStyle: MenuStyle(
          backgroundColor: 
            MaterialStatePropertyAll<Color>(BackgroundColors.bgBlue),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
        ),
        leadingIcon: leadingIcon,
        inputDecorationTheme: inputDecorationTheme,
        width: MediaQuery.of(context).size.width - 24,
        initialSelection: groupSpace.first.name,
        onSelected: (String? value) => handleChangeDropdownItem(value),  
        dropdownMenuEntries: groupSpace.map<DropdownMenuEntry<String>>((item) {
          return DropdownMenuEntry<String>(
            value: "${item.name}", 
            label: "${item.name}",
            style: btnstyle
          );
        }).toList(),
      );
    }

    return dropdownMenu;
  }
}