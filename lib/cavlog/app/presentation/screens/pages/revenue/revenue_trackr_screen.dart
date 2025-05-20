import 'package:barber_pannel/cavlog/app/data/repositories/fetch_revenue_day_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/custom_revenue_tracker/custom_revenu_tracker_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/revenue_dashbord_bloc/revenue_dashbord_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/date_range_cubit/date_range_cubit.dart'
    show DateRangeCubit;
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../provider/cubit/profiletab/profiletab_cubit.dart';
import '../../../provider/cubit/revenue_dashbord_cubit/revenue_dashbord_cubit.dart';
import '../../../widgets/revenue_widget/revenue_body_widget.dart';
class RevenueTrackrScreen extends StatelessWidget {
  const RevenueTrackrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfiletabCubit()),
        BlocProvider(create: (_) => RevenueDashbordCubit()),
        BlocProvider(create: (_) => DateRangeCubit()),
        BlocProvider(create: (_) => RevenueDashbordBloc(FetchRevenueDayRepositoryImpl())),
        BlocProvider(create: (_) => CustomRevenuTrackerBloc(FetchRevenueDayRepositoryImpl())),
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
                body: RevenueTrackrBodyWidget(screenWidth: screenWidth, screenHeight: screenHeight),
              ),
            ),
          );
        },
      ),
    );
  }
}

