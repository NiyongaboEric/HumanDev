import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String value;
  final List options;
  final Color color;
  final Function(dynamic)? onChanged;
  const CustomDropDownMenu({
    super.key,
    required this.options,
    this.onChanged,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: DropdownButtonFormField(
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                enabled: option != options[0],
                child: Text(
                  option,
                  style: TextStyle(
                    color: option != options[0] ? color : Colors.grey,
                  ),
                ),
              ),
            )
            .toList(),
        iconSize: 24,
        borderRadius: BorderRadius.circular(12),
        onChanged: onChanged,
        value: value,
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 24, color: color),
        decoration: InputDecoration(
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color.withOpacity(0.5)),
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: color.withOpacity(0.5))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color.withOpacity(0.5), width: 2)),
          errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red)),
          hintStyle: TextStyle(color: Colors.red),
          filled: true,
          fillColor: color.withOpacity(0.08),
        ),
      ),
    );
  }
}

class CustomDropDownMenuItem extends StatelessWidget {
  const CustomDropDownMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CustomDropDownMenuTwo extends StatelessWidget {
  CustomDropDownMenuTwo({
    super.key, 
    required this.groupSpace, 
    required this.handleChangeDropdownItem 
  });

  List<Group> groupSpace;
  Function(dynamic) handleChangeDropdownItem;
  
  @override
  Widget build(BuildContext context) {

    DropdownMenu dropdownMenu;

    ButtonStyle btnstyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll<Color>(SMSRecipientColors.primaryColor),
    );

    InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(10),
        borderSide:  const BorderSide(
          color: Color(0xFF031A38),
          width: 1
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(70),
        borderSide: const BorderSide(
          color: Color(0xff1877F2),
          width: 1
        ),
      ),
    );

    var leadingIcon = Icon(
      Icons.filter_list_alt,
      color: SMSRecipientColors.primaryColor
    );

    if (groupSpace.isEmpty) {
      List<String> data = ['No groups available'];
      dropdownMenu = DropdownMenu<String>(
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
            MaterialStatePropertyAll<Color>(BackgroundColors.bgBlue)
        ),
        leadingIcon: leadingIcon,
        inputDecorationTheme: inputDecorationTheme,
        width: 390,
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