
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/constant.dart';

class EarningsCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final String percentageText;

  const EarningsCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.percentageText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.10,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidgets.hight10(context),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppPalette.blackClr,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.032,
                right: screenWidth * 0.006,
                bottom: screenHeight * 0.032,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor),
                  Text(
                    percentageText,
                    style: TextStyle(
                      color: AppPalette.blackClr,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
