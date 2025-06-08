import 'package:flutter/material.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';



 SizedBox profileviewWidget(double screenWidth, BuildContext context,
      IconData icons, String heading, Color iconclr, {Color? textColor, int? maxLines}) {
    return SizedBox(
      width: screenWidth * 0.55,
      child: Row(children: [
        Icon(
          icons,
          color: iconclr,
        ),
        ConstantWidgets.width20(context),
        Expanded(
          child: Text(
            heading,
            style: TextStyle(
              color: textColor ?? AppPalette.whiteClr,
            ),
            maxLines: maxLines ?? 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }

IconButton iconsFilledDetail(
    {required BuildContext context,
    required Color fillColor,
    required double borderRadius,
    required Color forgroudClr,
    required double padding,
    required VoidCallback onTap,
    required IconData icon}) {
  return IconButton.filled(
    onPressed: onTap,
    icon: Icon(icon),
    style: IconButton.styleFrom(
      backgroundColor: fillColor,
      foregroundColor: forgroudClr,
      padding: EdgeInsets.all(padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}




  Column detailsPageActions(
      {required BuildContext context,
      required double screenWidth,
      required IconData icon,
      required VoidCallback onTap,
      Color ? colors,
      required String text}) {
    return Column(
      children: [
        iconsFilledDetail(
          icon: icon,
          forgroudClr:colors ?? Color(0xFFFEBA43),
          context: context,
          borderRadius: 15,
          padding:screenWidth > 600 ? 30 : screenWidth * .05,
          fillColor: Color.fromARGB(255, 248, 239, 216),
          onTap: onTap,
        ),
        Text(text)
      ],
    );
  }

