import 'package:flutter/material.dart';

import '../utilities/custom_colors.dart';

// Badge Enum
enum BadgeCard {
  debt,
  paid,
}

class ListCard extends StatelessWidget {
  final String title;
  final Widget? image;
  final String? subtitle;
  final Widget? action;
  final BadgeCard badge;
  const ListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.image, required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CustomColor.grey,
            width: 1,
          )),
      child: ListTile(
        leading: image,
        title: Row(children: [
          Text(
            title,
          ),
          // Status Badge
          const SizedBox(width: 8),
          badge == BadgeCard.debt ? _badge("Debt") : _badge("Paid"),
        ]),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: action,
      ),
    );
  }
}

Widget _badge(String message) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: message == "Debt" ? Colors.red : Colors.green, // Background color of the badge
    ),
    constraints: const BoxConstraints(
      // minWidth: 16,
      minHeight: 16,
    ),
    child: Text(
      message,
      style: const TextStyle(
        color: Colors.white, // Text color of the badge
        fontSize: 10,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
