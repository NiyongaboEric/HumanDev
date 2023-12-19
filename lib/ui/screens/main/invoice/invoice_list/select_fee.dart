import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

class SelectFee extends StatefulWidget {
  const SelectFee({super.key});

  @override
  State<SelectFee> createState() => _SelectFeeState();
}

class _SelectFeeState extends State<SelectFee> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<bool> isSelected = [true, false];
  List<Widget> children = [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text("All",
          style: TextStyle(
            fontSize: CustomFontSize.medium,
          )),
    ),
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Text(
          "Suggested for this student",
          style: TextStyle(fontSize: CustomFontSize.medium),
        )),
  ];
  List selectedFees = [];

  // Update Selected Fee Option
  _updateSelectedFeeOption(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColors.bgPurple,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        children: [
          _buildFeeItem(),
        ],
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
      elevation: 0,
      title: Text(
        "Select Fee",
        style: TextStyle(
          color: SecondaryColors.secondaryPurple,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return _buildNewItemDialog();
              },
            );
          },
          icon: Icon(
            Icons.add_rounded,
            size: 28,
            color: SecondaryColors.secondaryPurple,
          ),
        ),
      ],
      bottom: _buildPreferredSize(),
    );
  }

  // Build Preferred Size Widget
  PreferredSize _buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size.fromHeight(65),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                _updateSelectedFeeOption(index);
              },
              color: SecondaryColors.secondaryPurple,
              selectedColor: Colors.white,
              fillColor: TertiaryColors.tertiaryPurple,
              borderRadius: BorderRadius.circular(50),
              children: children,
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeeItem() {
    return ListTile(
        title: Text(
          "Tuition Fee",
          style: TextStyle(
            color: SecondaryColors.secondaryPurple,
            fontSize: CustomFontSize.medium,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "1000",
              style: TextStyle(
                color: SecondaryColors.secondaryPurple,
                fontSize: CustomFontSize.medium,
              ),
            ),
            SizedBox(width: 5),
            Checkbox(
              value: true,
              onChanged: (bool? value) {},
              activeColor: SecondaryColors.secondaryPurple,
            ),
          ],
        ));
  }

  // Build Floating Action Button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: TertiaryColors.tertiaryPurple,
        label: Text(
          "Save",
          style: TextStyle(
            color: Colors.white,
            fontSize: CustomFontSize.medium,
          ),
        ));
  }

  // Build New Item Dialog
  Widget _buildNewItemDialog() {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        "Add new item",
        style: TextStyle(
          color: SecondaryColors.secondaryPurple,
          fontSize: CustomFontSize.medium,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: "Name",
            controller: itemNameController,
            color: SecondaryColors.secondaryPurple,
          ),
          SizedBox(height: 10),
          // Row(
          //   children: [
          //     CustomTextField(
          //       hintText: "Amount",
          //       controller: amountController,
          //       color: SecondaryColors.secondaryPurple,
          //     ),
          //     SizedBox(width: 10),
          //     CustomTextField(
          //       hintText: "Price",
          //       controller: priceController,
          //       color: SecondaryColors.secondaryPurple,
          //     ),
          //   ],
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: SecondaryColors.secondaryPurple,
              fontSize: CustomFontSize.medium,
            ),
          ),
        ),
        DefaultBtn(
          onPressed: () {},
          text: "Add",
          btnColor: SecondaryColors.secondaryPurple,
          textColor: PrimaryColors.primaryPurple,
        ),
      ],
    );
  }
}
