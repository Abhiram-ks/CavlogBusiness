
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/date_range_cubit/date_range_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/date_range_cubit/date_range_state.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/date_renge_picker_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_custom_report_generate.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_tracker_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common/common_action_button.dart';
import '../../../../../core/common/snackbar_helper.dart';
import '../../../../../core/themes/colors.dart' show AppPalette;
import '../../../../../core/utils/constant/constant.dart';
import '../../provider/bloc/custom_revenue_tracker/custom_revenu_tracker_bloc.dart';

class CustomRevenuTracker extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const CustomRevenuTracker(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
final squareSize = (screenSize.width < screenSize.height ? screenSize.width : screenSize.height) * 0.4;
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
                  startDate =' ${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year}';
                }
                if (state.endDate != null) {
                  endDate =' ${state.endDate!.day}/${state.endDate!.month}/${state.endDate!.year}';
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
              label: "Generate Report",
              onTap: () {
                final state = context.read<DateRangeCubit>().state;

                if (state.startDate != null && state.endDate != null) {
                  DateTime start = state.startDate!;
                  DateTime end = state.endDate!;

                  if (end.isBefore(start)) {
                    final temp = start;
                    start = end;
                    end = temp;
                  }
                  context.read<CustomRevenuTrackerBloc>().add(RequstforTrackingRevenue(startTime: start, endTime: end));
                } else {
                  CustomeSnackBar.show(
                    context: context,
                    title: "Selection Warning!",
                    description:"Take initiative for selecting a date range before proceeding to the next step.",
                    titleClr: AppPalette.redClr,
                  );
                }
              },
            ),
            ConstantWidgets.hight20(context),
            CustomRevenueReportGenerate(screenWidth: screenWidth, screenHeight: screenHeight, squareSize: squareSize)
          ],
        ),
      ),
    );
  }
}
