

import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';

class CustomRevenuCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String startDateNotifier;
  final String endDateNotifier;
  final VoidCallback onTap;

  const CustomRevenuCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.startDateNotifier,
    required this.endDateNotifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
                padding: EdgeInsets.only(left: screenWidth * 0.04),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      'Track and Analyze Revenue',
                      style: TextStyle(
                        color: AppPalette.blackClr,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          startDateNotifier,
                          style: TextStyle(
                            color: AppPalette.blackClr,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                        ),
                        Text(
                          endDateNotifier,
                          style: const TextStyle(
                            color: AppPalette.blackClr,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ],
                )),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.025,
                  bottom: screenHeight * 0.025,
                  left: screenWidth * 0.045),
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppPalette.buttonClr,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: AppPalette.whiteClr,
                    ),
                    onPressed: onTap,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
