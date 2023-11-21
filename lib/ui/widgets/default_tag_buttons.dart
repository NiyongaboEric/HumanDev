import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

import '../utilities/custom_colors.dart';
import 'inputs/text_field.dart';

class DefaultTagButtons extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final Color? color;
  final Color textColor;
  final Color btnColor;
  final Color unselectedTag;
  final Color unselectedTagText;
  final Function(String) addTag;
  final Function(String) removeTag;
  const DefaultTagButtons({
    super.key,
    this.color,
    required this.tags,
    required this.selectedTags,
    required this.textColor,
    required this.btnColor,
    required this.unselectedTag,
    required this.unselectedTagText,
    required this.addTag,
    required this.removeTag,
  });

  @override
  State<DefaultTagButtons> createState() => _DefaultTagButtonsState();
}

class _DefaultTagButtonsState extends State<DefaultTagButtons> {
  // List<String> widget.selectedTags = [];
  // List<String> tags = [];
  TextEditingController tagController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleTag(bool selected, String tag) {
    setState(() {
      if (selected) {
        widget.selectedTags.add(tag);
      } else {
        widget.selectedTags.remove(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> tags = List.from(widget.tags);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "Tags",
              style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: widget.textColor,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  icon: Icon(
                    isEdit ? Icons.close : Icons.edit_outlined,
                    size: 28,
                    color: widget.textColor,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            children: [
              ...tags.asMap().entries.map((entry) {
                // int index = entry.key;
                String tag = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _toggleTag(!widget.selectedTags.contains(tag), tag);
                    },
                    child: Chip(
                      side: widget.selectedTags.contains(tag)
                          ? BorderSide.none
                          : BorderSide(color: widget.unselectedTag),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      deleteIcon: isEdit
                          ? Icon(
                              Icons.close_rounded,
                              color: widget.selectedTags.contains(tag)
                                  ? widget.textColor
                                  : Colors.black,
                              size: 16,
                            )
                          : null,
                      onDeleted: isEdit
                          ? () {
                              widget.removeTag(tag);
                            }
                          : null,
                      key: Key(tag),
                      label: Text(tag,
                          style: const TextStyle(fontSize: CustomFontSize.medium)),
                      backgroundColor: widget.selectedTags.contains(tag)
                          ? (widget.color ?? CustomColor.primaryLight)
                          : Colors.red.shade50,
                      labelStyle: TextStyle(
                        color: widget.selectedTags.contains(tag)
                            ? widget.textColor
                            : widget.unselectedTagText,
                      ),
                    ),
                  ),
                );
              }).toList(),
              isEdit
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              backgroundColor: Colors.red.shade50,
                              title: Text("Add new tag",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: SecondaryColors.secondaryRed,
                                      fontSize: CustomFontSize.large)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    color: widget.textColor,
                                    controller: tagController,
                                    hintText: "Tag",
                                  ),
                                  const SizedBox(height: 25),
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
                                        fontSize: CustomFontSize.medium,
                                        color: Colors.red.shade300),
                                  ),
                                ),
                                SizedBox(
                                    width: 150,
                                    height: 60,
                                    child: FloatingActionButton.extended(
                                        backgroundColor: widget.btnColor,
                                        onPressed: () {
                                          widget.addTag(tagController.text);
                                          tagController.clear();
                                          Navigator.pop(context);
                                        },
                                        label: Text(
                                          "Add tag",
                                          style: TextStyle(
                                            fontSize: CustomFontSize.medium,
                                            color: widget.textColor,
                                          ),
                                        ))),
                              ]),
                        );
                      },
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        color: widget.textColor,
                        size: 28,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
