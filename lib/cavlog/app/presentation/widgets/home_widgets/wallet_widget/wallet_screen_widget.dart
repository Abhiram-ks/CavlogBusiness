
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_overview_cards_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';

class WalletScreenWidget extends StatefulWidget {
  const WalletScreenWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<WalletScreenWidget> createState() => _WalletScreenWidgetState();
}

class _WalletScreenWidgetState extends State<WalletScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
      context.read<FetchWalletBloc>().add(FetchWalletEventRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Wallet',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              ConstantWidgets.hight10(context),
              Text(
                'Manage your wallet effortlessly — check history, monitor payments, and top up in seconds.',
              ),
            ],
          ),
        ),
        WalletOverviewCard(
          screenWidth: widget.screenWidth,
          screenHeight: widget.screenHeight,
        ),
        Expanded(
          child: WalletTransctionWidget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        )
      ],
    );
  }
}