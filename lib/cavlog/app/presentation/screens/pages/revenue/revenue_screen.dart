import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barber_service_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barber_wallet_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_transaction_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_screen_body.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/themes/colors.dart';

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                FetchWalletBloc(FetchBarberWalletRepositoryImpl())),
        BlocProvider(
            create: (context) => FetchBarberServiceBloc(
                repository: FetchBarberServiceRepositoryImpl())),
        BlocProvider(
            create: (context) =>
                FetchBookingBloc(FetchBookingRepositoryImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
              appBar: CustomAppBar(backgroundColor: AppPalette.blackClr,isTitle: true,title: 'Revenue',iconColor: AppPalette.whiteClr,),
              body: RevenueScreenBodyWidget(
                  screenWidth: screenWidth, screenHeight: screenHeight),
            );
          
        },
      ),
    );
  }
}
