
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import '../wallet_widget/wallet_balance_widget.dart';

class BookingCountWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const BookingCountWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.15,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15  : screenWidth * 0.05),
        child: Column(
          children: [
            ConstantWidgets.hight10(context),
            BlocBuilder<FetchBookingWithBarberBloc, FetchBookingWithUserStateBase>(
              builder: (context, state) {
                if (state is FetchBookingWithUserLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: walletBalanceWidget(
                      context: context,
                      iconColor: AppPalette.buttonClr,
                      balance: 'Loading..',
                      balanceColor: AppPalette.greyClr,
                      icon: Icons.book_rounded,
                      titile: 'Bookings',
                    ),
                  );
                } else if (state is FetchBookingWithUserLoaded) {
                  final booking = state.combo;
                  final bookingCount = booking;
                  return walletBalanceWidget(
                    context: context,
                    iconColor: AppPalette.buttonClr, 
                    balance:bookingCount.length.toString() , 
                    balanceColor: AppPalette.blackClr,
                    titile: 'Bookings',
                    icon: Icons.book_rounded,
                    );
                }
                else if (state is FetchBookingWithUserEmpty) {
                  return walletBalanceWidget(
                    context: context,
                    iconColor: AppPalette.redClr,
                    balance: '0',
                    balanceColor: AppPalette.redClr,
                    icon: Icons.book_rounded,
                    titile: 'No bookings available.',
                  );
                  
                }
                return walletBalanceWidget(
                    context: context,
                    iconColor: AppPalette.redClr,
                    balance: '0',
                    balanceColor: AppPalette.redClr,
                    icon: Icons.book_rounded,
                    titile: 'Booking fetch error.',);
              },
            )
          ],
        ),
      ),
    );
  }
}