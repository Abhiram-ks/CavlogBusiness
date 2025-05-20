import 'dart:developer';
import 'dart:ui';

import 'package:barber_pannel/cavlog/app/data/repositories/fetch_revenue_day_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/revenue_dashbord_bloc/revenue_dashbord_bloc.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../provider/cubit/profiletab/profiletab_cubit.dart';
import '../../../provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';

class RevenueTrackrScreen extends StatelessWidget {
  const RevenueTrackrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfiletabCubit()),
        BlocProvider(create: (_) => RevenueDashbordCubit()),
        BlocProvider(
            create: (_) => RevenueDashbordBloc(FetchRevenueDayRepositoryImpl()))
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

class RevenueTrackrBodyWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const RevenueTrackrBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<RevenueTrackrBodyWidget> createState() =>
      _RevenueTrackrBodyWidgetState();
}

class _RevenueTrackrBodyWidgetState extends State<RevenueTrackrBodyWidget> {
  @override
void initState() {
  super.initState();

  final cubit = context.read<RevenueDashbordCubit>();
  final bloc = context.read<RevenueDashbordBloc>();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    bloc.add(LoadRevenueData(filter: cubit.state));
  });

  cubit.stream.listen((newFilter) {
    bloc.add(LoadRevenueData(filter: newFilter));
  });
}


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            automaticIndicatorColorAdjustment: true,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppPalette.orengeClr,
            unselectedLabelColor: const Color.fromARGB(255, 128, 128, 128),
            indicatorColor: AppPalette.orengeClr,
            tabs: const [
              Tab(text: 'Dashboard'),
              Tab(text: 'Track Earnings'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                DashboardWidget(
                    screenWidth: widget.screenWidth,
                    screenHeight: widget.screenHeight),
                Center(child: Text('Earnings Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const DashboardWidget(
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
                if (state is RevenuDahsbordLoaded) {
                  final double earnings =  state.totalEarnings;
                  final  String totalEarnings = formatIndianCurrency(earnings);
                   return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstantWidgets.hight10(context),
                    EarningsCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        title: 'Earnings Overview',
                        amount: totalEarnings,
                        icon:state.isGrowth ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        iconColor: state.isGrowth ? AppPalette.greenClr : AppPalette.redClr,
                        percentageText:'${state.percentageGrowth.toStringAsFixed(2)} (%)'),
                    TotalBookigsCard(
                        title: 'Scheduled Sessions',
                        number: state.completedSessions,
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
                      sublabel:state.topServicesAmount,
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
                return Center(child: Text('the current state is $state'));
               
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

class CustomLineChart extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final List<String> months;
  final List<double> values;
  final double maxY;
  final double minY;

  const CustomLineChart({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.months,
    required this.values,
    required this.maxY,
    required this.minY,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = List.generate(
      months.length,
      (index) => {
        "month": months[index],
        "value": values[index],
      },
    );

    return PinchToZoomScrollableWidget(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: screenWidth * 0.96,
            height: screenHeight * 0.3,
            color: AppPalette.scafoldClr,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        bottom: screenHeight * 0.02,
                        left: screenWidth * 0.02,
                        right: screenWidth * 0.05),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 35,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    NumberFormat.compactCurrency(
                                            symbol: '', decimalDigits: 0)
                                        .format(value),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                int index = value.toInt();
                                if (index >= 0 && index < data.length) {
                                  return Text(
                                    data[index]["month"],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  );
                                } else {
                                  return const Text("");
                                }
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              data.length,
                              (index) => FlSpot(index.toDouble(),
                                  data[index]["value"].toDouble()),
                            ),
                            isCurved: true,
                            curveSmoothness: 0.3,
                            color: AppPalette.orengeClr,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppPalette.buttonClr,
                                  Color.fromARGB(
                                      (0.2 * 255).round(), 255, 255, 255),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            dotData: const FlDotData(show: true),
                            isStepLineChart: false,
                            isStrokeCapRound: true,
                            isStrokeJoinRound: true,
                            barWidth: 3,
                            gradient: LinearGradient(
                              colors: [
                                AppPalette.orengeClr,
                                AppPalette.orengeClr.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ],
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: AppPalette.whiteClr, width: 0.5),
                        ),
                        maxY: maxY,
                        minY: minY,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlobalColors {
  static const List<Color> segmentColors = [
    Color(0xFF000000), // Black
    Color(0xFF444444), // Dark Gray
    Color(0xFF888888), // Medium Gray
    Color(0xFFCCCCCC), // Light Gray
    Color.fromARGB(255, 225, 225, 225), // Almost White
  ];
}

class PieChartWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final List<Color> segmentColors;
  final List<double> segmentValues;
  final List<String> segmentLabels;
  final List<String> sublabel;

  const PieChartWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.segmentColors,
    required this.segmentValues,
    required this.segmentLabels,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rowData = List.generate(
        segmentLabels.length,
        (index) => {
              "color": segmentColors[index % segmentColors.length],
              "label": segmentLabels[index],
              "sublsbel": sublabel[index]
            });

    return PinchToZoomScrollableWidget(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: screenWidth * 0.97,
            height: screenHeight * 0.3,
            color: AppPalette.scafoldClr,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.08,
                            left: screenWidth * 0.01,
                          ),
                          child: Column(
                            children: rowData.map((data) {
                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      color: data["color"],
                                      width: screenHeight * 0.015,
                                      height: screenHeight * 0.015,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  SizedBox(
                                    width: screenWidth * 0.26,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data["label"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          data["sublsbel"],
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sections:
                                List.generate(segmentValues.length, (index) {
                              return PieChartSectionData(
                                value: segmentValues[index],
                                color: segmentColors.isNotEmpty
                                    ? segmentColors[
                                        index % segmentColors.length]
                                    : Colors.blue,
                                showTitle: true,
                                title: '${segmentValues[index].toStringAsFixed(2)}%',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                radius: 45 + (index * 7),
                                badgePositionPercentageOffset: 1.2,
                              );
                            }),
                            sectionsSpace: 1.8,
                            centerSpaceRadius: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TotalBookigsCard extends StatelessWidget {
  final String title;
  final String number;
  final double screenHeight;
  final double screenWidth;

  const TotalBookigsCard({
    super.key,
    required this.title,
    required this.number,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppPalette.blackClr,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            number,
            style: const TextStyle(
              color: AppPalette.blackClr,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class EarningsCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final String percentageText;

  const EarningsCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.percentageText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.10,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidgets.hight10(context),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppPalette.blackClr,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.032,
                right: screenWidth * 0.006,
                bottom: screenHeight * 0.032,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor),
                  Text(
                    percentageText,
                    style: TextStyle(
                      color: AppPalette.blackClr,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
