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
  const InvoiceCard({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.currency,
    required this.isVoid,
    required this.isPaid,
    required this.isDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
      decoration: ShapeDecoration(
        color: Color(0xFFE0E0E0),
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

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
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

  Stack _buildVoidText() {
    return Stack(
      children: [
        Positioned(
          left: 141,
          top: 40,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(0.0, 0.0)
              ..rotateZ(-0.35),
            child: Text(
              isVoid
                  ? 'Void'
                  : isDraft
                      ? 'Draft'
                      : isPaid
                          ? 'Paid'
                          : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF898989),
                fontSize: 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                height: 0.07,
              ),
            ),
          ),
        ),
      ],
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
              "$name",
              style: TextStyle(
                color: SecondaryColors.secondaryPurple,
                fontSize: CustomFontSize.large,
              ),
            ),
          ],
        ),
        Spacer(),
        isPaid ? Text(
          "Invoice #",
          style: TextStyle(
            color: TertiaryColors.tertiaryPurple,
            fontSize: CustomFontSize.large,
          ),
        ) : Container(),
      ],
    );
  }

  Widget _buildDateAndAmount() {
    var parsedDate = Constants.dateFormatParser(date);
    return Row(
      children: [
        Text(
          parsedDate,
          style: TextStyle(
            color: SecondaryColors.secondaryPurple.withOpacity(0.6),
            fontSize: CustomFontSize.extraSmall,
          ),
        ),
      ],
    );
  }
}
