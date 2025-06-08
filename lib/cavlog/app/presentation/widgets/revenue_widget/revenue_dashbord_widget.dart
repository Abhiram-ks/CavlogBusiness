import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_earnings_card_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_total_bookingcard_widget.dart'
    show TotalBookigsCard;
import 'package:barber_pannel/core/common/lottie_widget.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../domain/usecases/data_listing_usecase.dart';
import '../../provider/bloc/revenue_dashbord_bloc/revenue_dashbord_bloc.dart';
import '../../provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';
import 'revenue_linechart_widget.dart' show CustomLineChart;
import 'revenue_piechart_widget.dart' show PieChartWidget;

class DashboardWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const DashboardWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final squareSize = (screenSize.width < screenSize.height
            ? screenSize.width
            : screenSize.height) *
        0.4;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15 : screenWidth * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidgets.hight10(context),
            BlocBuilder<RevenueDashbordCubit, RevenueFilter>(
              builder: (context, filter) {
                return DropdownButton<RevenueFilter>(
                  borderRadius: BorderRadius.circular(0),
                  dropdownColor: AppPalette.whiteClr,
                  elevation: 1,
                  value: filter,
                  isExpanded: true,
                  onChanged: (newFilter) {
                    if (newFilter != null) {
                      context.read<RevenueDashbordCubit>().setFilter(newFilter);
                    }
                  },
                  items: RevenueFilter.values.map((RevenueFilter val) {
                    return DropdownMenuItem<RevenueFilter>(
                        value: val, child: Text(getFilterLabel(val)));
                  }).toList(),
                );
              },
            ),
            BlocBuilder<RevenueDashbordBloc, RevenueDashbordState>(
              builder: (context, state) {
                if (state is RevenueDashbordLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight50(context),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppPalette.buttonClr,
                              ),
                            ),
                            ConstantWidgets.width20(context),
                            Text('Loading...'),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                if (state is RevenuDahsbordLoaded) {
                  final double earnings = state.totalEarnings;
                  final String totalEarnings = formatIndianCurrency(earnings);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstantWidgets.hight10(context),
                      EarningsCard(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          title: 'Earnings Overview',
                          amount: totalEarnings,
                          icon: state.isGrowth
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          iconColor: state.isGrowth
                              ? AppPalette.greenClr
                              : AppPalette.redClr,
                          percentageText:
                              '${state.percentageGrowth.toStringAsFixed(2)} (%)'),
                      TotalBookigsCard(
                          title: 'Scheduled Sessions',
                          number: '${state.completedSessions} Bookings',
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      TotalBookigsCard(
                          title: 'Work Legacy',
                          number: state.workingMinutes,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      ConstantWidgets.hight30(context),
                      Text('Visual Analytics Section'),
                      ConstantWidgets.hight10(context),
                      PieChartWidget(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        segmentColors: GlobalColors.segmentColors,
                        segmentValues: state.segmentValues,
                        segmentLabels: state.topServices,
                        sublabel: state.topServicesAmount,
                      ),
                      ConstantWidgets.hight10(context),
                      CustomLineChart(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        months: state.graphLabels,
                        values: state.graphValues,
                        maxY: state.maxY,
                        minY: state.minY,
                      ),
                    ],
                  );
                }
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight50(context),
                      Center(
                          child: LottiefilesCommon(
                              assetPath: LottieImages.lodinglottie,
                              width: squareSize,
                              height: squareSize)),
                      Text(
                        'Something Went Wrong',
                        style: TextStyle(color: AppPalette.redClr),
                      ),
                      Text(
                        'No data available right now.Please try again.',
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

String getFilterLabel(RevenueFilter filter) {
  switch (filter) {
    case RevenueFilter.today:
      return 'Today';
    case RevenueFilter.weekly:
      return 'Weekly';
    case RevenueFilter.mothely:
      return 'Monthly';
    case RevenueFilter.yearly:
      return 'Annually';
  }
}
