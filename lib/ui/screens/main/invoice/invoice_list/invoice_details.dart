import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/invoice_list/select_fee.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';

import '../../../../widgets/invoice/invoice_table.dart';

enum InvoiceType { EDIT, CREATE }

class InvoiceDetails extends StatefulWidget {
  final InvoiceType invoiceType;
  final InvoiceModel invoiceData;
  const InvoiceDetails({super.key, required this.invoiceType, required this.invoiceData});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  var date = DateTime.now();
  _updateDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColors.bgPurple,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        children: [
          _buildInvoiceDraft(),
          SizedBox(height: 20),
          _buildNames("ALex", "Diana"),
          SizedBox(height: 20),
          _buildDatePicker(),
          SizedBox(height: 60),
          _buildInvoiceItems(),
          // SizedBox(height: 60),
          _buildPaymentSchedule(),
          SizedBox(height: 60),
          _actionButtons(),
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
        widget.invoiceType == InvoiceType.CREATE
            ? "Create invoice"
            : "Edit invoice",
        style: TextStyle(
          color: SecondaryColors.secondaryPurple,
        ),
      ),
      actions: [],
    );
  }

  // Build Invoice Details

  // Build Invoice Title
  //Build Invoice Draft
  Widget _buildInvoiceDraft() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 90,
          height: 1,
          decoration: BoxDecoration(
            color: TertiaryColors.tertiaryPurple,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Text(
          widget.invoiceType == InvoiceType.CREATE
              ? "Invoice draft"
              : "Invoice draft",
          style: TextStyle(
            color: TertiaryColors.tertiaryPurple,
            fontSize: CustomFontSize.large,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: 90,
          height: 1,
          decoration: BoxDecoration(
            color: TertiaryColors.tertiaryPurple,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  // Names and Titles
  Widget _buildNames(String toName, String forName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "To: ",
              style: TextStyle(
                color: TertiaryColors.tertiaryPurple,
                fontSize: CustomFontSize.large,
              ),
            ),
            Text(
              toName,
              style: TextStyle(
                color: Colors.black,
                fontSize: CustomFontSize.large,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "For: ",
              style: TextStyle(
                color: TertiaryColors.tertiaryPurple,
                fontSize: CustomFontSize.large,
              ),
            ),
            Text(
              forName,
              style: TextStyle(
                color: Colors.black,
                fontSize: CustomFontSize.large,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    var tertiaryColor = MaterialColor(
      TertiaryColors.tertiaryPurple.value,
      <int, Color>{
        50: TertiaryColors.tertiaryPurple,
        100: TertiaryColors.tertiaryPurple,
        200: TertiaryColors.tertiaryPurple,
        300: TertiaryColors.tertiaryPurple,
        400: TertiaryColors.tertiaryPurple,
        500: TertiaryColors.tertiaryPurple,
        600: TertiaryColors.tertiaryPurple,
        700: TertiaryColors.tertiaryPurple,
        800: TertiaryColors.tertiaryPurple,
        900: TertiaryColors.tertiaryPurple,
      },
    );

    return DatePicker(
      onSelect: _updateDate,
      date: date,
      bgColor: BackgroundColors.bgPurple,
      borderColor: SecondaryColors.secondaryPurple,
      pickerColor: tertiaryColor,
      pickerTimeLime: PickerTimeLime.both,
    );
  }

  // Build Invoice Items
  Widget _buildInvoiceItems() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Items",
              style: TextStyle(
                color: TertiaryColors.tertiaryPurple,
                fontSize: CustomFontSize.large,
              ),
            ),
            const Spacer(),
            FloatingActionButton.extended(
              onPressed: () {
                nextScreen(context: context, screen: SelectFee());
              },
              label: Text("Add a standard item",
                  style: TextStyle(
                    color: TertiaryColors.tertiaryPurple,
                    fontSize: CustomFontSize.small,
                  )),
              backgroundColor: PrimaryColors.primaryPurple,
            ),
          ],
        ),
        SizedBox(height: 20),
        InvoiceTable(
          invoiceTableType: InvoiceTableType.ITEMS,
          itemItems: widget.invoiceData.invoiceItems,
          paymentSchedules: widget.invoiceData.paymentSchedules,
        ),
      ],
    );
  }

  // Build Payment Schedule
  Widget _buildPaymentSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment schedule",
          style: TextStyle(
            color: TertiaryColors.tertiaryPurple,
            fontSize: CustomFontSize.large,
          ),
        ),
        SizedBox(height: 20),
        InvoiceTable(
          invoiceTableType: InvoiceTableType.PAYMENT_SCHEDULE,
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultBtn(
          onPressed: () {},
          text: "Save as draft",
          btnColor: PrimaryColors.primaryPurple,
          textColor: SecondaryColors.secondaryPurple,
        ),
        DefaultBtn(
          onPressed: () {},
          text: "Send invoice",
          btnColor: SecondaryColors.secondaryPurple,
          textColor: PrimaryColors.primaryPurple,
        ),
      ],
    );
  }
}
