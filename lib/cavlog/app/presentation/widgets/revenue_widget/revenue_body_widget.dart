
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/revenue_dashbord_bloc/revenue_dashbord_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/revenue/revenue_trackr_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_dashbord_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/colors.dart';
import '../../provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';

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
               CustomRevenuTracker(screenWidth: widget.screenWidth, screenHeight: widget.screenHeight)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
