
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/themes/colors.dart';

TextButton timePickerwidget({
  required BuildContext context,
  required TimeOfDay initialTime,
  required Function(Time) onTimeChanged,
  required String labelText,
}) {
  return TextButton(
    onPressed: () {
      Navigator.of(context).push(
        showPicker(
            is24HrFormat: true,
            context: context,
            value: Time.fromTimeOfDay(initialTime, 0),
            onChange: onTimeChanged,
            duskSpanInMinutes: 120,
            blurredBackground: true,
            iosStylePicker: true,
            focusMinutePicker: true,
            okText: 'schedule',
            backgroundColor: AppPalette.scafoldClr,
            cancelStyle: TextStyle(color: AppPalette.blackClr),
            okStyle: TextStyle(
              color: AppPalette.orengeClr,
            )),
      );
    },
    child: Text(
      "$labelText :",
      style: TextStyle(
        color: AppPalette.blueClr,
        fontSize: 16,
      ),
    ),
  );
}

