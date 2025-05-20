
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../provider/cubit/date_range_cubit/date_range_cubit.dart';
import '../../provider/cubit/date_range_cubit/date_range_state.dart';
import '../settings_widget/setting_time_management/pageone_settings_time_management/settings_time_mangement_pageone_date_picker.dart' as table_calendar show isSameDay;

class DateRangePicker extends StatelessWidget {
  const DateRangePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateRangeCubit, DateRangeState>(
      builder: (context, state) {
        return Container(
          color: AppPalette.whiteClr,
          child: Padding(
            padding: EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: AppPalette.whiteClr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TableCalendar(
                    firstDay: DateTime(2025),
                    lastDay: DateTime.now(),
                    focusedDay: state.focusedDay,
                    enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
                    selectedDayPredicate: (day) => table_calendar.isSameDay(day, state.startDate ?? DateTime(2000)) ||table_calendar.isSameDay(day, state.endDate ?? DateTime(2000)),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppPalette.orengeClr,
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle: TextStyle(color: AppPalette.greyClr),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, _) {
                        final isStart = state.startDate != null && table_calendar.isSameDay(day, state.startDate!);
                        final isEnd = state.endDate != null && table_calendar.isSameDay(day, state.endDate!);
                        final isInRange = state.startDate != null &&
                            state.endDate != null &&
                            day.isAfter(state.startDate!) &&
                            day.isBefore(state.endDate!);

                        if (isStart || isEnd) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppPalette.blackClr,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: AppPalette.whiteClr,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else if (isInRange) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppPalette.hintClr,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: AppPalette.blackClr,
                                ),
                              ),
                            ),
                          );
                        }

                        return null;
                      },
                    ),
                    onDaySelected: (selectedDay, focusedDay) {context.read<DateRangeCubit>().onDaySelected(selectedDay);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.read<DateRangeCubit>().reset(),
                        child: const Text("Reset Date", style: TextStyle(color: AppPalette.blackClr)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close", style: TextStyle(color: AppPalette.blueClr)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}