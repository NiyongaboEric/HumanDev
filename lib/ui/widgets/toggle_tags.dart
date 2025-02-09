import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';

import '../screens/main/reminder/reminder_types/conversation/log_conversation.dart';
import '../utilities/font_sizes.dart';

class ToggleTags extends StatefulWidget {
  final List<ToggleTagComponents> tags;
  final List<DefaultTagsSettings> selectedTags;
  final Color defaultColor;
  final Color btnColor;
  final Color textColor;
  final Color unselectedTagBg;
  final Color unselectedTextColor;
  final Function(DefaultTagsSettings) addTag;
  final Function(DefaultTagsSettings) removeTag;
  const ToggleTags({
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
  State<ToggleTags> createState() => _ToggleTagsState();
}

class _ToggleTagsState extends State<ToggleTags> {
  @override
  Widget build(BuildContext context) {
    List<ToggleTagComponents> tags = List.from(widget.tags);
    return Column(
      children: [
        ...tags.asMap().entries.map((entry) {
          ToggleTagComponents tag = entry.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChoiceChip(
                    showCheckmark: false,
                    selectedColor: widget.btnColor,
                    backgroundColor: widget.defaultColor,
                    label: Text(
                      tag.positive.name!,
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        color: widget.textColor,
                      ),
                    ),
                    selected: widget.selectedTags.contains(
                      tag.positive,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        widget.addTag(tag.positive);
                        widget.removeTag(tag.negative);
                      } else {
                        // widget.addTag(tag.negative);
                        widget.removeTag(tag.positive);
                      }
                    },
                  ),
                  const Icon(CupertinoIcons.arrow_left_right),
                  ChoiceChip(
                    selectedColor: widget.btnColor,
                    backgroundColor: widget.defaultColor,
                    showCheckmark: false,
                    label: Text(
                      tag.negative.name!,
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        color: widget.textColor,
                      ),
                    ),
                    selected: widget.selectedTags.contains(
                      tag.negative,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        widget.addTag(tag.negative);
                        widget.removeTag(tag.positive);
                      } else {
                        // widget.addTag(tag.positive);
                        widget.removeTag(tag.negative);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10,)
            ],
          );
        })
      ],
    );
  }
}
