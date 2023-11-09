// import 'package:flutter/material.dart';
// import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';

// import '../../data/school/model/school_model.dart';

// class SchoolCard extends StatelessWidget {
//   final School school;
//   const SchoolCard({super.key, required this.school});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: CustomColor.grey)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 100,
//             width: 80,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               color: CustomColor.primaryLight.withOpacity(0.5),
//             ),
//             child: const Icon(
//               Icons.school_rounded,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   school.name,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(school.address,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     style: TextStyle(color: Colors.grey, fontSize: 13)),
//                 Text(school.phoneNumber ?? "Tel No -",
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     style: TextStyle(color: Colors.grey, fontSize: 12)),
//                 Container(
//                   height: 40,
//                 )
//               ]),
//           const Spacer(),
//           IconButton(
//             onPressed: () {
//             },
//             icon: Icon(Icons.arrow_forward_ios_rounded,
//                 color: Colors.grey, size: 20),
//           )
//         ],
//       ),
//     );
//   }
// }
