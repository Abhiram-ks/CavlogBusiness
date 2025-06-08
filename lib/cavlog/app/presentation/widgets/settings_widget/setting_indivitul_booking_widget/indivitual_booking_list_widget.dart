
import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/common/lottie_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../../core/utils/image/app_images.dart';
import '../../../provider/bloc/fetchings/fetch_booking_user/fetch_booking_user_bloc.dart';
import '../../../screens/settings/bookings_screen/booking_details_screen.dart';
import '../../home_widgets/wallet_widget/wallet_tranasction_card_widget.dart';

class IndivitualBookingListWidget extends StatelessWidget {
  final double screenWidth;
  final String userId;
  final double screenHeight;
  const IndivitualBookingListWidget(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppPalette.whiteClr,
      color: AppPalette.buttonClr,
      onRefresh: () async {
        context.read<FetchBookingUserBloc>().add(FetchBookingUserRequest(userId: userId));
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15 : screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchBookingUserBloc, FetchBookingUserState>(
              builder: (context, state) {
                if (state is FetchBookingUserLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: SizedBox(
                      height: screenHeight * 0.8,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return TrasactionCardsWalletWidget(
                            ontap: () {},
                            screenHeight: screenHeight,
                            mainColor: AppPalette.hintClr,
                            amount: '+ ₹500.00',
                            amountColor: AppPalette.greyClr,
                            status: 'Loading..',
                            statusIcon: Icons.check_circle_outline_outlined,
                            id: 'Transaction #${index + 1}',
                            stusColor: AppPalette.greyClr,
                            dateTime: DateTime.now().toString(),
                            method: 'Online Banking',
                            description:
                                "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingUserEmptys) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidgets.hight50(context),
                          LottiefilesCommon(
                              assetPath: LottieImages.emptyData,
                              width: screenWidth * .6,
                              height: screenHeight * 0.35),
                          Text("No records available at this time."),
                          Text("No activity found — time to take action!",
                              style: TextStyle(color: AppPalette.blackClr))
                        ]),
                  );
                } 
                else if (state is FetchBookingUserLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.combo.length,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.combo[index];
                      final isOnline =booking.status.toLowerCase().contains('credit');
                      final DateTime converter = convertToDateTime(booking.slotDate);
                      final String date = formatDate(converter);
                      final double totalServiceAmount = booking
                          .serviceType.values
                          .fold(0.0, (sum, value) => sum + value);
                      return TrasactionCardsWalletWidget(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingDetailsScreen(
                                        barberId: booking.barberId,
                                        userId: booking.userId,
                                        docId: booking.bookingId!)));
                          },
                          screenHeight: screenHeight,
                          amount: totalServiceAmount.toStringAsFixed(2),
                          amountColor: switch (
                              booking.serviceStatus.toLowerCase()) {
                            'completed' => AppPalette.greenClr,
                            'pending' => AppPalette.orengeClr,
                            'cancelled' => AppPalette.redClr,
                            _ => AppPalette.hintClr,
                          },
                          dateTime: date,
                          description: isOnline
                              ? 'Sent ₹${totalServiceAmount.toStringAsFixed(2)} via ${booking.paymentMethod}'
                              : 'Received ₹${totalServiceAmount.toStringAsFixed(2)} via ${booking.paymentMethod}',
                          id: 'Booking code: ${booking.otp}',
                          method: 'Payment Method: ${booking.paymentMethod}',
                          status: booking.serviceStatus,
                          statusIcon: switch (
                              booking.serviceStatus.toLowerCase()) {
                            'completed' => Icons.check_circle_outline_outlined,
                            'pending' => Icons.pending_actions_rounded,
                            'cancelled' => Icons.free_cancellation_rounded,
                            _ => Icons.help_outline,
                          },
                          stusColor: switch (
                              booking.serviceStatus.toLowerCase()) {
                            'completed' => AppPalette.greenClr,
                            'pending' => AppPalette.orengeClr,
                            'cancelled' => AppPalette.redClr,
                            _ => AppPalette.hintClr,
                          });
                    },
                  );
                }

                return Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.cloud_download_fill),
                        Text(
                            "Oops! Something went wrong. We're having trouble processing your request. Please try again."),
                            IconButton(onPressed: (){
                              context
                                  .read<FetchBookingUserBloc>()
                                  .add(FetchBookingUserRequest(userId: userId));
                            },icon:  Icon( CupertinoIcons.refresh))
                      ]),
                );
              },
            ),
            ConstantWidgets.hight20(context)
          ],
        ),
      ),
    );
  }
}