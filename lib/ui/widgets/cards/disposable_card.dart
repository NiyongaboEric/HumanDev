import 'package:flutter/material.dart';

import '../../utilities/custom_colors.dart';

class DisposableCard extends StatelessWidget {
  final Widget content;
  final Function() onDispose;
  final Function() onTap;
  const DisposableCard({
    super.key,
    required this.content,
    required this.onDispose,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 140, maxWidth: 110),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: CustomColor.grey),
              ),
              child: content,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: InkWell(
              onTap: onDispose,
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        )
      ],
    );
  }
}
