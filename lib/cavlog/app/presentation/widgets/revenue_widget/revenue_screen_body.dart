

import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_grid_builder_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_track_custom_widget.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevenueScreenBodyWidget extends StatefulWidget {
  const RevenueScreenBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<RevenueScreenBodyWidget> createState() =>
      _RevenueScreenBodyWidgetState();
}

class _RevenueScreenBodyWidgetState extends State<RevenueScreenBodyWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchWalletBloc>().add(FetchWalletEventRequest());
      context.read<FetchBarberServiceBloc>().add(FetchBarberServiceRequestEvent());
      context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .03),
        child: Column(
          children: [
            ConstantWidgets.hight10(context),
            RevanueContainer(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight),
            ConstantWidgets.hight10(context),
            RevenuePortionGridWidget(widget: widget),
          ],
        ),
      ),
    );
  }
}

