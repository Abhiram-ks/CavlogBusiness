


import 'package:flutter/material.dart';

import '../../../../../../core/utils/constant/constant.dart';

Row paymentSummaryTextWidget(
    {required BuildContext context,
    required String prefixText,
    required String suffixText,
    required TextStyle suffixTextStyle,
    required TextStyle prefixTextStyle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          prefixText,
          style: suffixTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ConstantWidgets.width40(context),
      Text(
        suffixText,
        style: prefixTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}



