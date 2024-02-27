import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/number_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:collection/collection.dart' show IterableExtension;

import '../../../../../data/constants/shared_prefs.dart';
import '../../../../../data/space/model/space_model.dart';
import '../../../auth/space_bloc/space_bloc.dart';

var sl = GetIt.instance;

class SelectFee extends StatefulWidget {
  final List<ItemFee> selectedFees;

  const SelectFee({super.key, required this.selectedFees});

  @override
  State<SelectFee> createState() => _SelectFeeState();
}

class _SelectFeeState extends State<SelectFee> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var prefs = sl<SharedPreferenceModule>();
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
  List<ItemFee> selectedFees = [];

  @override
  void initState() {
    // Space space = prefs.getSpaces().first;
    // standardItems = space.spaceSettings?.standardItem ?? [];
    // selectedFees.addAll(widget.selectedFees);
    logger.d(selectedFees.map((e) => e.name).toList());
    context.read<SpaceBloc>().add(SpaceEventGetSpaces());
    super.initState();
  }

  // Update Selected Fee Option
  _updateSelectedFeeOption(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });
  }

  List<StandardItem> standardItems = [];

  // Handle Space Settings Change
  void _handleSpaceSettingsChange(BuildContext context, SpaceState state) {
    if (state.status == SpaceStateStatus.success) {
      standardItems = state.spaces.first.spaceSettings?.standardItem ?? [];
    }
    if (state.status == SpaceStateStatus.updateSuccess) {
      standardItems = state.spaces.first.spaceSettings?.standardItem ?? [];
    }
    updateParameters();
  }

  void updateParameters() {
    selectedFees.clear();
    selectedFees.addAll(widget.selectedFees);

    selectedFees.removeWhere((item) => !standardItems.any((element) =>
        element.name.toString().trim() == item.name.toString().trim()));

    List<StandardItem> unselectedStandardItem = standardItems
        .where((each) => !selectedFees.any((element) => element.name == each.name))
        .toList();
    List<ItemFee> unselectedFees = unselectedStandardItem
        .map((each) => ItemFee(
            name: each.name,
            price: each.price is double ? each.price : each.price.toDouble(),
            isSelected: false,
            isStandard: true))
        .toList();
    selectedFees.addAll(unselectedFees);

    for (ItemFee item in selectedFees) {
      item.isStandard = true;
    }
  }

  // Form Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceBloc, SpaceState>(
      listener: (context, state) {
        _handleSpaceSettingsChange(context, state);
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: BackgroundColors.bgPurple,
          appBar: _buildAppBar(),
          floatingActionButton:
              standardItems.isNotEmpty ? _buildFloatingActionButton() : null,
          body: state.isLoading
              ? Center(
                  child: GFLoader(
                  type: GFLoaderType.ios,
                  loaderColorOne: SecondaryColors.secondaryPurple,
                  loaderColorTwo: SecondaryColors.secondaryPurple,
                  loaderColorThree: SecondaryColors.secondaryPurple,
                ))
              : standardItems.isNotEmpty
                  ? ListView(
                      children: standardItems
                          .map((each) => _buildFeeItem(ItemFee(
                              name: each.name,
                              price: each.price is double
                                  ? each.price
                                  : each.price.toDouble(),
                              isSelected: selectedFees.any((element) =>
                                  element.name == each.name &&
                                  element.isSelected == true),
                              isStandard: true)))
                          .toList())
                  : Center(
                      child: Text(
                        "No standard items available",
                        style: TextStyle(
                          color: SecondaryColors.secondaryPurple,
                          fontSize: CustomFontSize.medium,
                        ),
                      ),
                    ),
        );
      },
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
          itemFee.name ?? "",
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
              value: itemFee.isSelected,
              onChanged: (bool? value) {
                if (value == null) return;
                setState(() {
                  ItemFee? item = selectedFees.firstWhereOrNull(
                      (element) => element.name == itemFee.name);
                  if (item != null) {
                    item.isSelected = value;
                  }
                  logger.w(selectedFees.map((e) => '${e.name} ${e.isSelected}').toList());
                });
                // logger.i(selectedFees);
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
          logger.t(selectedFees.map((e) => e.isSelected).toList());
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
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              hintText: "Name",
              controller: itemNameController,
              color: SecondaryColors.secondaryPurple,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Name is required";
                }
                return null;
              },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Price is required";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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
            // setState(() {
            //   itemFees.add(ItemFee(
            //     id: itemFees.length + 1,
            //     name: itemNameController.text,
            //     price: int.parse(priceController.text),
            //   ));
            // });
            if (_formKey.currentState!.validate()) {
              context.read<SpaceBloc>().add(SpaceEventUpdateStandardItems([
                    ...standardItems,
                    StandardItem(
                      name: itemNameController.text,
                      price: (int.parse(priceController.text)).toDouble(),
                    )
                  ]));
              Navigator.pop(context);
              itemNameController.clear();
              amountController.clear();
              priceController.clear();
            }
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
  // final int? id;
  final String? name;
  final double? price;
  bool? isStandard;
  bool isSelected;

  // final int? vat;

  ItemFee({this.name, this.price, this.isStandard, this.isSelected = true});
}
