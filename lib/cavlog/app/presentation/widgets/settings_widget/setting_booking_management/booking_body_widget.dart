
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_management/booking_builder_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_management/booking_filtering_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';

class BookingScreenWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const BookingScreenWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<BookingScreenWidget> createState() => _BookingScreenWidgetState();
}

class _BookingScreenWidgetState extends State<BookingScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchBookingWithBarberBloc>()
          .add(FetchBookingWithUserRequest());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *.15 : widget.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Overview',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                'Keep full control of your appointments,  monitor booking statuses, access client details, and ensure a smooth schedule every day.'
              ),
              ConstantWidgets.hight20(context),
              MybookingFilteringCards(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        Expanded(
          child: BookingListWIdget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        ),
      ],
    );
  }
}
