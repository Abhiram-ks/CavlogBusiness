import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/bookings_screen/booking_details_screen.dart';
import 'package:barber_pannel/core/common/lottie_widget.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import '../../home_widgets/wallet_widget/wallet_tranasction_card_widget.dart';

class BookingListWIdget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const BookingListWIdget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppPalette.whiteClr,
      color: AppPalette.buttonClr,
      onRefresh: () async {
        context
            .read<FetchBookingWithBarberBloc>()
            .add(FetchBookingWithUserRequest());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15 : screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchBookingWithBarberBloc,
                FetchBookingWithUserStateBase>(
              builder: (context, state) {
                if (state is FetchBookingWithUserLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: SizedBox(
                      height: screenHeight * 0.8,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            ConstantWidgets.hight10(context),
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
                            description:"Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingWithUserEmpty) {
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
                else if (state is FetchBookingWithUserLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.combo.length,
                    separatorBuilder: (_, __) => ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.combo[index];
                      final isUserName = booking.user.userName!.isNotEmpty && booking.user.userName != 'null';
                      final String date = formatDate(booking.booking.createdAt);
                      final String time =  formatTimeRange(booking.booking.createdAt);
                      return TrasactionCardsWalletWidget(
                          ontap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen(barberId:booking.booking.barberId, userId:booking.booking.userId, docId:booking.booking.bookingId ?? '')));
                          },
                          screenHeight: screenHeight,
                          amount: booking.booking.otp,
                          amountColor: switch (
                            booking.booking.serviceStatus.toLowerCase()) {
                            'completed' => AppPalette.greenClr,
                            'pending' => AppPalette.orengeClr,
                            'cancelled' => AppPalette.redClr,
                            _ => AppPalette.hintClr,
                          },
                          dateTime: '$date At $time',
                          description: isUserName
                              ? 'Booking by : ${booking.user.userName}'
                              : 'Booking by: ${booking.user.email}',
                          id:'Payment Method: ${booking.booking.paymentMethod}',
                          method: booking.user.address ?? 'No Address Provided',
                          status: booking.booking.serviceStatus,
                          statusIcon: switch ( booking.booking.serviceStatus.toLowerCase()) {
                            'completed' => Icons.check_circle_outline_outlined,
                            'pending' => Icons.pending_actions_rounded,
                            'cancelled' => Icons.free_cancellation_rounded,
                            _ => Icons.help_outline,
                          },
                          stusColor: switch (
                              booking.booking.serviceStatus.toLowerCase()) {
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
                        ConstantWidgets.hight50(context),
                        Icon(CupertinoIcons.cloud_download_fill),
                        Text(
                            "Oops! Something went wrong. We're having trouble processing your request. Please try again."),
                            IconButton(onPressed: (){
                               context
                                  .read<FetchBookingWithBarberBloc>()
                                  .add(FetchBookingWithUserRequest());
                            }, icon: Icon(CupertinoIcons.refresh))
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
