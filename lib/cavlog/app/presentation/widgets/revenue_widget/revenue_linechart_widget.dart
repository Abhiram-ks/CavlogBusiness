
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

import '../../../../../core/themes/colors.dart';

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
                                // ignore: deprecated_member_use
                                AppPalette.orengeClr.withOpacity(0.3)

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
