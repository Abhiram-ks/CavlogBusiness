
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../../core/themes/colors.dart';
import '../../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/models/date_model.dart';
import '../../../../../domain/usecases/is_slottime_exceeded_usecase.dart';
import '../../../../provider/bloc/booking_generate_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import '../../../../provider/bloc/fetchings/fetch_slots_dates_bloc/fetch_slots_dates_bloc.dart';
import '../../../../provider/cubit/booking_generate_cubit/calender_picker/calender_picker_cubit.dart';

BlocBuilder<CalenderPickerCubit, CalenderPickerState> pageTwoCalenderPicker() {
    return BlocBuilder<CalenderPickerCubit, CalenderPickerState>(
      builder: (context, calenderState) {
        return BlocBuilder<FetchSlotsDatesBloc, FetchSlotsDatesState>(
          builder: (context, dateState) {
            if (dateState is FetchSlotsDatesSuccess) {
              final List<DateModel> availableDates = dateState.dates;

              final Set<DateTime> enabledDates = availableDates.map((dateModel) => parseDate(dateModel.date)).toSet();
              return Column(
                children: [
                  TableCalendar(
                    focusedDay: calenderState.selectedDate,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(
                      DateTime.now().year + 3,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(calenderState.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (enabledDates.contains(DateTime(selectedDay.year,
                          selectedDay.month, selectedDay.day))) {
                        context.read<CalenderPickerCubit>().updateSelectedDate(selectedDay);
                        context.read<FetchSlotsSpecificdateBloc>().add(FetchSlotsSpecificdateRequst(selectedDay));
                      }
                    },
                    calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppPalette.orengeClr,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppPalette.buttonClr,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: AppPalette.whiteClr,
                          fontWeight: FontWeight.bold,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                        defaultTextStyle:
                            TextStyle(fontWeight: FontWeight.w900)),
                    calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                      final isEnable = enabledDates
                          .contains(DateTime(day.year, day.month, day.day));

                      if (!isEnable) {
                        return Center(
                            child: Text(
                          '${day.day}',
                          style: TextStyle(color: AppPalette.greyClr),
                        ));
                      }
                      return Center(
                            child: Text(
                          '${day.day}',
                          style: TextStyle(color: AppPalette.blackClr, fontWeight: FontWeight.w900),
                        ));
                    }),
                  ),
                  ConstantWidgets.hight10(context),
                ],
              );
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300] ?? AppPalette.greyClr,
              highlightColor: AppPalette.whiteClr,
              child: TableCalendar(
                focusedDay: calenderState.selectedDate,
                firstDay: DateTime.now(),
                lastDay: DateTime(
                  DateTime.now().year + 3,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month'
                },
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: AppPalette.greyClr, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppPalette.greyClr, shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                        color: AppPalette.whiteClr,
                        fontWeight: FontWeight.bold),
                    defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                    outsideDaysVisible: false),
              ),
            );
          },
        );
      },
    );
  }