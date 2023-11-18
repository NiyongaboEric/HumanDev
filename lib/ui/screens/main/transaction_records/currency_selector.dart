import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/drop_down_menu.dart';

import '../../../utilities/font_sizes.dart';

class CurrencySelector extends StatefulWidget {
  final String initialCurrency;
  final MaterialColor primaryColor;
  final Color secondaryColor;
  const CurrencySelector({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.initialCurrency,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late String selectedCurrency;
  Color color = Colors.black;
  // update selected currency
  void updateCurrency(value) {
    setState(() {
      selectedCurrency = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedCurrency = widget.initialCurrency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.primaryColor.shade50,
      appBar: AppBar(
        backgroundColor: widget.primaryColor.shade100,
        iconTheme: IconThemeData(
          color: widget.secondaryColor,
        ),
        title: Text(
          "Currency Selector",
          style: TextStyle(
            color: widget.secondaryColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: widget.primaryColor.shade300,
        onPressed: () {
          Navigator.pop(
            context,
            selectedCurrency,
          );
        },
        label: Text("Done",
            style: TextStyle(
              fontSize: CustomFontSize.large,
              color: widget.secondaryColor,
            )),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(height: 30),
          CustomDropDownMenu(
            options: const [
              "Select Currency",
              ...Constants.currencyOptions,
            ],
            value: selectedCurrency,
            color: color,
            onChanged: updateCurrency,
          ),
        ],
      ),
    );
  }
}
