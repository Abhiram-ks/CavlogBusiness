import 'package:flutter/material.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';

SizedBox profileviewWidget(double screenWidth, BuildContext context,
    IconData icons, String heading, Color iconclr,
    {Color? textColor, int? maxline, double? widget}) {
  return SizedBox(
    width: widget ?? screenWidth * 0.55,
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
          maxLines: maxline ?? 1,
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
