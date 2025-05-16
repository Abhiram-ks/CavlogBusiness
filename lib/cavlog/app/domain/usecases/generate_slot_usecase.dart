import 'dart:developer';
import 'package:flutter/material.dart';
import '../../presentation/provider/cubit/booking_generate_cubit/duration_picker/duration_picker_cubit.dart';



class SlotGenerator {
  static List<Map<String, dynamic>> generateSlots({
    required DateTime date,
    required TimeOfDay start,
    required TimeOfDay end,
    required DurationTime duration,
  }) {
    IntravelConverter converter = IntravelConverter(duration);
    Duration slotDuration = converter.getDurationType();

    final DateTime startDateTime = DateTime(date.year, date.month, date.day, start.hour, start.minute);
    final DateTime endDateTime = DateTime(date.year, date.month, date.day, end.hour, end.minute);

    List<Map<String, dynamic>> slotList = [];

    DateTime currentSlotStart = startDateTime;

    while (currentSlotStart.isBefore(endDateTime)) {
      DateTime currentSlotEnd = currentSlotStart.add(slotDuration);

      if (currentSlotEnd.isAfter(endDateTime)) {
        break;
      }

      slotList.add({  
        'startDateTime': currentSlotStart,
        'endDateTime': currentSlotEnd,
      });

      currentSlotStart = currentSlotEnd;
    }

    log('Generated Slot Map List: $slotList');
    return slotList;
  }
}



class IntravelConverter {
  DurationTime duration;

  IntravelConverter(this.duration);

  Duration getDurationType() {
    switch (duration) {
      case DurationTime.basic:
        return Duration(minutes: 30);
      case DurationTime.standard:
        return Duration(minutes: 45);
      case DurationTime.elite:
        return Duration(hours: 1);
    }
  }
}