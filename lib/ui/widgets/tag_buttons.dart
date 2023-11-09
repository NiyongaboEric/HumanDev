// import 'package:flutter/material.dart';
// import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
// import 'package:seymo_pay_mobile_application/ui/widgets/buttons/filled_btn.dart';
// import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

// import '../utilities/custom_colors.dart';

// class TagToggleButtons extends StatefulWidget {
//   final List<String> tags;
//   const TagToggleButtons({
//     Key? key,
//     required this.tags,
//   }) : super(key: key);

//   @override
//   State<TagToggleButtons> createState() => _TagToggleButtonsState();
// }

// class _TagToggleButtonsState extends State<TagToggleButtons> {
//   List<String> _selectedTags = [];
//   List<String> tags = [];
//   TextEditingController tagController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     tags = List.from(widget.tags);
//   }

//   void _toggleTag(bool selected, String tag) {
//     setState(() {
//       if (selected) {
//         _selectedTags.add(tag);
//       } else {
//         _selectedTags.remove(tag);
//       }
//     });
//   }

//   // Add To tag List
//   void _addTag(String text) {
//     setState(() {
//       tags.add(text);
//       tagController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: [
//         ...tags.asMap().entries.map((entry) {
//           // int index = entry.key;
//           String tag = entry.value;

//           return Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: ChoiceChip(
//               showCheckmark: false,
//               key: Key(tag),
//               label: Text(tag),
//               selected: _selectedTags.contains(tag),
//               onSelected: (selected) => _toggleTag(selected, tag),
//               selectedColor: CustomColor.primaryLight,
//               backgroundColor: Colors
//                   .white70, // TODO: change to white12 when it's available in stable channel https://github.com
//               labelStyle: TextStyle(
//                 color:
//                     _selectedTags.contains(tag) ? Colors.white : Colors.black,
//               ),
//             ),
//           );
//         }).toList(),
//         SizedBox(
//           width: 100,
//           child: FilledBtn(
//             text: "Other",
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                     actionsAlignment: MainAxisAlignment.spaceBetween,
//                     title: const Text("Add New Field"),
//                     content: Column(mainAxisSize: MainAxisSize.min, children: [
//                       const SizedBox(height: 10),
//                       CustomTextField(
//                         color: Colors.blue,
//                         hintText: "Tag",
//                         controller: tagController,
//                       )
//                     ]),
//                     actions: [
//                       // Cancel
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text("Cancel"),
//                       ),
//                       // Submit
//                       SizedBox(
//                         width: 75,
//                         child: FilledBtn(
//                           onPressed: () {
//                             _addTag(tagController.text);
//                             Navigator.pop(context);
//                           },
//                           text: "Add",
//                           btnVariant: BtnVariant.primary,
//                           loading: false,
//                         ),
//                       ),
//                     ]),
//               );
//             },
//             loading: false,
//             btnVariant: BtnVariant.primary,
//           ),
//         ),
//       ],
//     );
//   }
// }
