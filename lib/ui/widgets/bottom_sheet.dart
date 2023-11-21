import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';

class CustomBottomSheet extends StatefulWidget {
  final String title;
  final List<Widget> widgets;
  final Color? color;
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.widgets, this.color,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double screeHeight = MediaQuery.of(context).size.height;
    return StatefulBuilder(
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: screeHeight * 0.6,
            decoration: BoxDecoration(
              color: widget.color ?? Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: CustomColor.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shrinkWrap: true,
                    children: [
                      ...widget.widgets,
                    ],
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        );
      }
    );
  }
}
