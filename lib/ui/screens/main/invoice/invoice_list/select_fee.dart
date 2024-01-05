import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/number_field.dart';
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
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text("All",
          style: TextStyle(
            fontSize: CustomFontSize.medium,
          )),
    ),
    const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Text(
          "Suggested for this student",
          style: TextStyle(fontSize: CustomFontSize.medium),
        )),
  ];
  List<ItemFee> itemFees = [
    ItemFee(id: 1, name: "Tuition Fee", price: 1000),
    ItemFee(id: 2, name: "Feeding Fee", price: 85),
  ];
  List<ItemFee> selectedFees = [];

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
          ...itemFees.map((each) => _buildFeeItem(each)).toList(),
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
      preferredSize: const Size.fromHeight(65),
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
              fillColor: LightInvoiceColors.dark,
              borderRadius: BorderRadius.circular(50),
              children: children,
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeeItem(ItemFee itemFee) {
    return ListTile(
        title: Text(
          itemFee.name!,
          style: TextStyle(
            color: SecondaryColors.secondaryPurple,
            fontSize: CustomFontSize.medium,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${itemFee.price}",
              style: TextStyle(
                color: SecondaryColors.secondaryPurple,
                fontSize: CustomFontSize.medium,
              ),
            ),
            const SizedBox(width: 5),
            Checkbox(
              value: selectedFees.contains(itemFee),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedFees.add(itemFee);
                  } else {
                    selectedFees.remove(itemFee);
                  }
                });
              },
              activeColor: SecondaryColors.secondaryPurple,
            ),
          ],
        ));
  }

  // Build Floating Action Button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
        key: const Key("save-item-fee"),
        onPressed: () {
          Navigator.pop(context, selectedFees);
        },
        backgroundColor: LightInvoiceColors.dark,
        label: const Text(
          "Select",
          style: TextStyle(
            color: Colors.white,
            fontSize: CustomFontSize.medium,
          ),
        ));
  }

  // Build New Item Dialog
  Widget _buildNewItemDialog() {
    return AlertDialog(
      backgroundColor: PrimaryColors.primaryPurple,
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
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 110,
                child: CustomNumberField(
                  hintText: "Amount",
                  controller: amountController,
                  color: SecondaryColors.secondaryPurple,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 110,
                child: CustomNumberField(
                  hintText: "Price",
                  controller: priceController,
                  color: SecondaryColors.secondaryPurple,
                ),
              ),
            ],
          ),
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
              color: TertiaryColors.tertiaryPurple,
              fontSize: CustomFontSize.medium,
            ),
          ),
        ),
        DefaultBtn(
          onPressed: () {
            setState(() {
              itemFees.add(ItemFee(
                id: itemFees.length + 1,
                name: itemNameController.text,
                price: int.parse(priceController.text),
              ));
            });
            Navigator.pop(context);
          },
          text: "Add",
          btnColor: TertiaryColors.tertiaryPurple,
          textColor: PrimaryColors.primaryPurple,
        ),
      ],
    );
  }
}

class ItemFee {
  final int? id;
  final String? name;
  final int? price;

  ItemFee({this.id, this.name, this.price});  
}