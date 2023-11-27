import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';

class WordCase {
  static capitalizedFirstLetter(String text) {
    return text.split(' ').map((word) => word.capitalize()).join(' ');
  }
}

class CustomTogglesButton extends StatefulWidget {
  const CustomTogglesButton({
    super.key,
    required this.togglesSelectionBool,
    required this.togglesSelectionEnum,
  });

  final List<bool> togglesSelectionBool;
  final List<Enum> togglesSelectionEnum;

  @override
  State<CustomTogglesButton> createState() => _CustomTogglesButtonState();
}

class _CustomTogglesButtonState extends State<CustomTogglesButton> {
  @override
  Widget build(BuildContext context) {

    List<Widget> toggleOptions() {
      List<Widget> togglesList = [];
      for (var item in widget.togglesSelectionEnum) {
        togglesList.add(
          SizedBox(
            width: (MediaQuery.of(context).size.width - 20) / 4,
            child:
                Center(child: Text(WordCase.capitalizedFirstLetter(item.name))),
          ),
        );
      }
      return togglesList;
    }

    void updateTogglesButtonSelection(int index) {
      setState(() {
        for (int i = 0; i < widget.togglesSelectionBool.length; i++) {
          if (i == index) {
            widget.togglesSelectionBool[i] = true;
          } else {
            widget.togglesSelectionBool[i] = false;
          }
        }
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ToggleButtons(
            borderWidth: 1.3,
            renderBorder: true,
            selectedColor: Colors.white,
            fillColor: SMSRecipientColors.primaryColor,
            borderRadius: BorderRadius.circular(50),
            selectedBorderColor: SMSRecipientColors.primaryColor,
            borderColor: SMSRecipientColors.primaryColor,
            color: SMSRecipientColors.primaryColor,
            constraints: BoxConstraints.expand(
              width: constraints.minWidth / 4.3,
            ),
            isSelected: widget.togglesSelectionBool,
            onPressed: updateTogglesButtonSelection,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
            children: toggleOptions(),
          ),
        );
      },
    );
  }
}
