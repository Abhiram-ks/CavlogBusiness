import 'package:barber_pannel/cavlog/app/data/repositories/fetch_revenue_day_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/revenue_dashbord_bloc/revenue_dashbord_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/date_range_cubit/date_range_cubit.dart'
    show DateRangeCubit;
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/date_range_cubit/date_range_state.dart';
import 'package:barber_pannel/core/common/common_action_button.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/cubit/profiletab/profiletab_cubit.dart';
import '../../../provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';
import '../../../widgets/revenue_widget/revenue_body_widget.dart';
import '../../../widgets/settings_widget/setting_time_management/pageone_settings_time_management/settings_time_mangement_pageone_date_picker.dart'
    as table_calendar;

class RevenueTrackrScreen extends StatelessWidget {
  const RevenueTrackrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfiletabCubit()),
        BlocProvider(create: (_) => RevenueDashbordCubit()),
        BlocProvider(
            create: (_) =>
                RevenueDashbordBloc(FetchRevenueDayRepositoryImpl())),
        BlocProvider(create: (_) => DateRangeCubit())
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(),
                body: RevenueTrackrBodyWidget(
                    screenWidth: screenWidth, screenHeight: screenHeight),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
                    selectedDayPredicate: (day) =>
                        table_calendar.isSameDay(
                            day, state.startDate ?? DateTime(2000)) ||
                        table_calendar.isSameDay(
                            day, state.endDate ?? DateTime(2000)),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        final isStart = state.startDate != null &&
                            table_calendar.isSameDay(day, state.startDate!);
                        final isEnd = state.endDate != null &&
                            table_calendar.isSameDay(day, state.endDate!);
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
                    onDaySelected: (selectedDay, focusedDay) {
                      context.read<DateRangeCubit>().onDaySelected(selectedDay);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.read<DateRangeCubit>().reset(),
                        child: const Text("Reset Date",
                            style: TextStyle(color: AppPalette.blackClr)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close",
                            style: TextStyle(color: AppPalette.blueClr)),
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

class CustomRevenuTracker extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const CustomRevenuTracker(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidgets.hight10(context),
            BlocBuilder<DateRangeCubit, DateRangeState>(
              builder: (context, state) {
                String startDate = 'Start Date';
                String endDate = 'End Date';
                if (state.startDate != null) {
                  startDate =
                      ' ${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year}';
                }
                if (state.endDate != null) {
                  endDate =
                      ' ${state.endDate!.day}/${state.endDate!.month}/${state.endDate!.year}';
                }
                return CustomRevenuCard(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  startDateNotifier: startDate,
                  endDateNotifier: endDate,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (bottomSheetContext) {
                        return BlocProvider.value(
                          value: context.read<DateRangeCubit>(),
                          child: const DateRangePicker(),
                        );
                      },
                    );
                  },
                );
              },
            ),
            ConstantWidgets.hight10(context),
            ActionButton(
              screenWidth: screenWidth,
              screenHight: screenHeight,
              label: 'Track Progress',
              onTap: () {
                final state = context.read<DateRangeCubit>().state;

                if (state.startDate != null && state.endDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Tracking from ${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year} '
                          'to ${state.endDate!.day}/${state.endDate!.month}/${state.endDate!.year}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  CustomeSnackBar.show(
                    context: context,
                    title: "Selection Warning!",
                    description:
                        "Take initiative for selecting a date range before proceeding to the next step.",
                    titleClr: AppPalette.redClr,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
