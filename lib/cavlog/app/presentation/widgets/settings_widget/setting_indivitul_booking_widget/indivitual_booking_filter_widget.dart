

import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_management/booking_filter_custom_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../provider/bloc/fetchings/fetch_booking_user/fetch_booking_user_bloc.dart';

class IndivitualBookingFilteringCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String userId;
  const IndivitualBookingFilteringCard(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.048,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            BookingFilteringCards(
              label: 'All Booking',
              icon: Icons.history_rounded,
              colors: Colors.black,
              onTap: () {
                context
                    .read<FetchBookingUserBloc>()
                    .add(FetchBookingUserRequest(userId: userId));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Completed',
              icon: Icons.check_circle_outline_sharp,
              colors: Colors.green,
              onTap: () {
                context.read<FetchBookingUserBloc>().add(
                    FetchBookingUserFiltering(
                        filter: 'Completed', userId: userId));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Cancelled',
              icon: Icons.free_cancellation_rounded,
              colors: AppPalette.redClr,
              onTap: () {
                context.read<FetchBookingUserBloc>().add(
                    FetchBookingUserFiltering(
                        filter: 'Cancelled', userId: userId));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeClr,
              onTap: () {
                context.read<FetchBookingUserBloc>().add(
                    FetchBookingUserFiltering(
                        filter: 'Pending', userId: userId));
              },
            ),
          ],
        ),
      ),
    );
  }
}
