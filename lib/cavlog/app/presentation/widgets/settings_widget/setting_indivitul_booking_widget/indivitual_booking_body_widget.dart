
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_indivitul_booking_widget/indivitual_booking_filter_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_indivitul_booking_widget/indivitual_booking_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_booking_user/fetch_booking_user_bloc.dart';

class IndivitualBookingBodyWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  const IndivitualBookingBodyWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.userId});

  @override
  State<IndivitualBookingBodyWidget> createState() =>
      _IndivitualBookingBodyWidgetState();
}

class _IndivitualBookingBodyWidgetState
    extends State<IndivitualBookingBodyWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingUserBloc>().add(FetchBookingUserRequest(userId: widget.userId));
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
                  'Track detailed booking history and revenue insights for each customer. Monitor loyalty, frequency, and overall impact on your shop’s success.'),
              ConstantWidgets.hight20(context),
              IndivitualBookingFilteringCard(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
                userId: widget.userId,
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        Expanded(
          child: IndivitualBookingListWidget(
              userId: widget.userId,
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        ),
      ],
    );
  }
}