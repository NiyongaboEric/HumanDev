import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

class ReminderTags extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final Color defaultColor;
  final Color btnColor;
  final Color textColor;
  final Color unselectedTagBg;
  final Color unselectedTextColor;
  final Function(String) addTag;
  final Function(String) removeTag;
  const ReminderTags({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.defaultColor,
    required this.btnColor,
    required this.textColor,
    required this.unselectedTagBg,
    required this.unselectedTextColor,
    required this.addTag,
    required this.removeTag,
  });

  @override
  State<ReminderTags> createState() => _ReminderTagsState();
}

class _ReminderTagsState extends State<ReminderTags> {
  @override
  Widget build(BuildContext context) {
    List<String> tags = List.from(widget.tags);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.asMap().entries.map(
        (entry) {
          String tag = entry.value;
          return ChoiceChip(
            showCheckmark: false,
            selectedColor: widget.btnColor,
            backgroundColor: widget.defaultColor,
            label: Text(
              tag,
              style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: widget.textColor,
              ),
            ),
            selected: widget.selectedTags.contains(tag),
            onSelected: (selected) {
              if (selected) {
                widget.addTag(tag);
              } else {
                widget.removeTag(tag);
              }
            },
          );
        },
      ).toList(),
    );
  }
}
