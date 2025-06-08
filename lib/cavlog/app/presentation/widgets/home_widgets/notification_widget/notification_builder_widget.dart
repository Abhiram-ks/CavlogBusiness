
import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_tranasction_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetchings/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import '../../../screens/settings/bookings_screen/booking_details_screen.dart';

RefreshIndicator notificationWidgetBuilder(
    BuildContext context, double screenHeight, double screenWidth) {
  return RefreshIndicator(
    backgroundColor: AppPalette.whiteClr,
    color: AppPalette.buttonClr,
    onRefresh: () async {
      context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithUserFileterRequest(filtering: 'Pending'));
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth*.15 : screenWidth * 0.02),
        child: Column(
          children: [
            BlocBuilder<FetchBookingWithBarberBloc, FetchBookingWithUserStateBase>(
              builder: (context, state) {
                if (state is FetchBookingWithUserLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: SizedBox(
                      height: screenHeight * 0.6,
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
                            description: "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingWithUserEmpty) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined),
                        Text(  "You have no notifications at the moment."),
                        Text("No Notification yet!",
                            style: TextStyle(color: AppPalette.orengeClr))
                      ]);
                } else if (state is FetchBookingWithUserLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.combo.length,
                    separatorBuilder: (_, __) => ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.combo[index];
                      final isUser =   booking.user.userName!.isNotEmpty && booking.user.userName != 'null';
                      final isAddress = booking.user.address!.isNotEmpty && booking.user.address != 'null';
                      final DateTime converter = convertToDateTime(booking.booking.slotDate);
                      final String date = formatDate(converter);

                      return TrasactionCardsWalletWidget(
                        ontap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen(barberId: booking.booking.barberId, userId: booking.booking.userId, docId: booking.booking.bookingId ?? '')));
                        },
                        screenHeight: screenHeight,
                        amount: isUser   ? booking.booking.otp
                            : booking.booking.otp,
                        amountColor: isUser
                            ? AppPalette.blackClr
                            : AppPalette.redClr,
                        dateTime:date,
                        description: '${isUser ? 'Booking Name' : 'Personal Details Hided'}: ${booking.user.userName}',
                        id: 'Method: ${booking.booking.paymentMethod}',
                        method: isAddress ? 'Address: ${booking.user.address}' : 'No address availble at the moment',
                        status: booking.booking.serviceStatus,
                        statusIcon: booking.booking.serviceStatus.toLowerCase() == 'pending' ? Icons.pending_actions_rounded : Icons.check_circle_outline_outlined,
                        stusColor: booking.booking.serviceStatus.toLowerCase() == 'pending'
                            ? AppPalette.redClr 
                            : AppPalette.greenClr,
                      );
                    },
                  );
                }
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swap_horiz),
                      Text(
                          "Oops! Something went wrong. We're having trouble processing your request. Please try again."),
                      InkWell(
                          onTap: () async {
                           context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithUserFileterRequest(filtering: 'Pending'));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.refresh, color: AppPalette.blueClr),
                              ConstantWidgets.width20(context),
                              Text("Refresh",
                                  style: TextStyle(
                                      color: AppPalette.blueClr,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ))
                    ]);
              },
            ),
            ConstantWidgets.hight20(context)
          ],
        ),
      ),
    ),
  );
}
