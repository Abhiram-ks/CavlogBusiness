import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_linechart_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_total_bookingcard_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/lottie_widget.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../provider/bloc/custom_revenue_tracker/custom_revenu_tracker_bloc.dart';
import 'revenue_earnings_card_widget.dart';
import 'revenue_piechart_widget.dart';

class CustomRevenueReportGenerate extends StatelessWidget {
  const CustomRevenueReportGenerate({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.squareSize,
  });

  final double screenWidth;
  final double screenHeight;
  final double squareSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomRevenuTrackerBloc, CustomRevenuTrackerState>(
      builder: (context, state) {
        if (state is CustomRevenuTrackerLoading) {
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
        if (state is CustomRevenuTrackerLoaded) {
          final double earnings = state.totalEarnings;
          final String totalEarnings = formatIndianCurrency(earnings);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EarningsCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  title: 'Earnings Overview',
                  amount: totalEarnings,
                  icon: CupertinoIcons.graph_square_fill,
                  iconColor: AppPalette.greenClr,
                  percentageText: 'Timeframe '),
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
        if (state is CustomRevenuTrackerEmptys ||
            state is CustomRevenuTrackerFailure) {
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
                Text( 'Something Went Wrong',
                  style: TextStyle(color: AppPalette.redClr),
                ),
                Text('No data available right now.Please try again.',
                ),
              ],
            ),
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
              Text('Track and analyze your revenue'),
              Text('Choose a date range to monitor performance'),
            ],
          ),
        );
      },
    );
  }
}
