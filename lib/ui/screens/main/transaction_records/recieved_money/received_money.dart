import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/constants/home_sections_model.dart';

import '../../person/students.dart';

class ReceivedMoney extends StatefulWidget {
  const ReceivedMoney({super.key});

  @override
  State<ReceivedMoney> createState() => _ReceivedMoneyState();
}

class _ReceivedMoneyState extends State<ReceivedMoney> {
  @override
  Widget build(BuildContext context) {
    List<HomeSection> receivedMoney = [
      HomeSection(
        title: "Tuition fees",
        color: Colors.green.shade100,
        icon: Icon(
          Icons.school_rounded,
          size: 36,
          color: SecondaryColors.secondaryGreen,
        ),
        onPressed: () {
          nextScreen(
              context: context,
              screen: const Students(
                select: false,
                option: StudentOption.tuition,
              ));
        },
      ),
      HomeSection(
        title: "Feeding fees",
        color: Colors.green.shade100,
        icon: Icon(
          Icons.fastfood_rounded,
          color: SecondaryColors.secondaryGreen,
          size: 36,
        ),
        onPressed: () {
          nextScreen(
            context: context,
            screen: const Students(
              select: true,
              option: StudentOption.feeding,
            ),
          );
        },
      ),
      HomeSection(
        title: "Other",
        color: Colors.green.shade100,
        icon: Icon(
          Icons.more_horiz,
          color: SecondaryColors.secondaryGreen,
          size: 36,
        ),
        onPressed: () {},
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text("Received money",
            style: TextStyle(
              color: SecondaryColors.secondaryGreen,
            )),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(height: 30),
          ...receivedMoney.map((e) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: e.onPressed,
                    child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: e.color,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 5), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 10),
                                e.icon,
                              ],
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  e.title,
                                  style: TextStyle(
                                    fontSize: CustomFontSize.medium,
                                    color: SecondaryColors.secondaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ))
        ],
      ),
    );
  }
}
