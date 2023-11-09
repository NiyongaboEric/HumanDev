import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final List<Widget>? contentList;
  final String? title;
  final String? cancelText;
  final String? okText;
  final Function? onPressedOk;
  final bool? isShowCancelButton;
  final Color? primaryColor;
  final Color? secondaryColor;
  const CustomAlertDialog({
    super.key,
    required this.contentList,
    required this.title,
    required this.onPressedOk,
    required this.isShowCancelButton,
    required this.primaryColor,
    required this.secondaryColor,
    this.cancelText,
    this.okText,
  });

  @override
  Widget build(BuildContext context) {
    // Custom Alert Dialog with maximum width
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: contentList ?? [],
        ),
      ),
      actions: <Widget>[
        if (isShowCancelButton != null && isShowCancelButton!)
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            onPressedOk!();
          },
        ),
      ],
    );
  }
}
