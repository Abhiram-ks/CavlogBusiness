
import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';

class TotalBookigsCard extends StatelessWidget {
  final String title;
  final String number;
  final double screenHeight;
  final double screenWidth;

  const TotalBookigsCard({
    super.key,
    required this.title,
    required this.number,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppPalette.blackClr,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            number,
            style: const TextStyle(
              color: AppPalette.blackClr,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}