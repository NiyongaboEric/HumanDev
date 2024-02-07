import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';

import '../../utilities/colors.dart';
import '../../utilities/font_sizes.dart';

class InvoiceCard extends StatelessWidget {
  final String name;
  final String date;
  final String amount;
  final String currency;
  final bool isVoid;
  final bool isPaid;
  final bool isDraft;
  final dynamic? paidAmount;
  final String? invoiceNumber;
  const InvoiceCard({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.currency,
    required this.isVoid,
    required this.isPaid,
    required this.isDraft,
    this.paidAmount,
    this.invoiceNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
      decoration: ShapeDecoration(
        color: const Color(0xffeaeaea),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.01),
        ),
      ),
      child: Column(
        children: [
          _buildNameAndInvoiceNumber(),
          _buildDivider(),
          _buildDateAndAmount(),
        ],
      ),
    );
  }

      // Badge Info
    String _badgeInfo() {
      if (isVoid) {
        return "Void";
      } else if (isDraft) {
        return "Draft";
      } else if (isPaid) {
        return "Paid";
      } else if (!isPaid && !isDraft && !isVoid) {
        return "Unpaid";
      } else {
        return "";
      }
    }

    // Badge Color
    Color _badgeColor() {
      if (isVoid) {
        return Color(0xFFE0E0E0);
      } else if (isDraft) {
        return Color(0xFF68D5FF);
      } else if (isPaid) {
        return Color(0xFF027A48);
      } else if (!isPaid && !isDraft && !isVoid) {
        return Color(0xFFF2CA0C);
      } else {
        return Color(0xFFE0E0E0);
      }
    }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.70,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x191F0048),
          ),
        ),
      ),
    );
  }

  // Build Badge
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: _badgeColor(),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          _badgeInfo(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: CustomFontSize.extraSmall,
            fontWeight: FontWeight.w400,
            height: 0.07,
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndInvoiceNumber() {
    return Row(
      children: [
        Row(
          children: [
            Text(
              "For ",
              style: TextStyle(
                color: SecondaryColors.secondaryPurple.withOpacity(0.6),
                fontSize: CustomFontSize.large,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                color: SecondaryColors.secondaryPurple,
                fontSize: CustomFontSize.large,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildBadge(),
      ],
    );
  }

  Widget _buildDateAndAmount() {
    var parsedDate = Constants.dateFormatParser(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          parsedDate,
          style: TextStyle(
            color: SecondaryColors.secondaryPurple.withOpacity(0.6),
            fontSize: CustomFontSize.extraSmall,
          ),
        ),
        Text(
          isDraft || isVoid ? " - " : "$invoiceNumber",
          style: TextStyle(
            color: SecondaryColors.secondaryPurple.withOpacity(0.6),
            fontSize: CustomFontSize.extraSmall,
          ),
        ),
        Row(
          children: [
            Text(
              "${paidAmount != null ? paidAmount : "--"}",
              style: TextStyle(
                fontSize: CustomFontSize.extraSmall,
              ),
            ),
            Text(
              "  of",
              style: TextStyle(
                color: SecondaryColors.secondaryPurple.withOpacity(0.6),
                fontSize: CustomFontSize.extraSmall,
              ),
            ),
            Text(
              " $amount $currency",
              style: TextStyle(
                color: SecondaryColors.secondaryPurple,
                fontSize: CustomFontSize.extraSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
