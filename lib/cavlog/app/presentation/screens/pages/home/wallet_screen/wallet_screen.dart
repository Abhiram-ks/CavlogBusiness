import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barber_wallet_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_transaction_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/themes/colors.dart';
import '../../../../widgets/home_widgets/wallet_widget/wallet_screen_widget.dart';
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
         create: (context) => FetchBookingBloc(FetchBookingRepositoryImpl())),
        BlocProvider( create: (context) => FetchWalletBloc(FetchBarberWalletRepositoryImpl())),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return ColoredBox(
          color: AppPalette.hintClr,
          child: SafeArea(
              child: Scaffold(
            appBar: CustomAppBar(),
            body: WalletScreenWidget(
                screenWidth: screenWidth, screenHeight: screenHeight),
          )),
        );
      }),
    );
  }
}


