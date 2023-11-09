// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/recieved_money/tuition_fee/bloc/tuition_fees_bloc.dart';
// import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';

// class History extends StatefulWidget {
//   const History({super.key});

//   @override
//   State<History> createState() => _HistoryState();
// }

// class _HistoryState extends State<History> {
//   // Get All Transactions/Tuition Fess
//   getAllTuitionFees() {
//     context.read<TuitionBloc>().add(const GetAllTuitionEvent());
//   }

//   @override
//   void initState() {
//     super.initState();
//     getAllTuitionFees();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TuitionBloc, TuitionState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("History"),
//             centerTitle: true,
//           ),
//           body: state.isLoading?
//             Center(child: GFLoader(type: GFLoaderType.ios),):
//            ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             children: [
//               ListView.separated(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) => ListTile(
//                   title: Text(state.tuitionFees[index].reason!),
//                   subtitle: Text("${state.tuitionFees[index].currency!} ${state.tuitionFees[index].amount!}"),
//                 ),
//                 separatorBuilder: (context, index) => const Divider(color: CustomColor.grey,),
//                 itemCount: 3,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
