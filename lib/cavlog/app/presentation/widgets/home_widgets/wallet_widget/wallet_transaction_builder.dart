
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_bloc/fetch_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/bookings_screen/booking_details_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/wallet_widget/wallet_tranasction_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';

RefreshIndicator walletTransactionWidgetBuilder(
    BuildContext context, double screenHeight, double screenWidth) {
  return RefreshIndicator(
    backgroundColor: AppPalette.whiteClr,
    color: AppPalette.buttonClr,
    onRefresh: () async {
      context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchBookingBloc, FetchBookingState>(
              builder: (context, state) {
                if (state is FetchBookingLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: SizedBox(
                      height: screenHeight * 0.5,
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
                            description:
                                "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingEmpty) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet_rounded),
                        Text(
                            "Currently, there are no transaction history available."),
                        Text("No transactions yet!",
                            style: TextStyle(color: AppPalette.orengeClr))
                      ]);
                } else if (state is FetchBookingSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.bookings.length,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      final iscredited =
                          booking.transaction.toLowerCase().contains('debited');
                      final isOnline = booking.paymentMethod
                          .toLowerCase()
                          .contains('online banking');
                      final originalAmount = booking.amountPaid.toDouble();
                      return TrasactionCardsWalletWidget(
                        ontap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen(barberId: booking.barberId, userId: booking.userId, docId: booking.bookingId ?? '')));
                        },
                        screenHeight: screenHeight,
                        amount: iscredited
                            ? '+ ₹$originalAmount'
                            : '- ₹${booking.refund?.toStringAsFixed(2)}',
                        amountColor: iscredited
                            ? AppPalette.greenClr
                            : AppPalette.redClr,
                        dateTime: DateFormat('dd/MM/yyyy').format(booking.createdAt),
                        description:
                            '${iscredited ? 'Recived' : 'Refunded'}: ${booking.paymentMethod} transfer of ₹${booking.amountPaid.toStringAsFixed(2)}',
                        id: isOnline
                            ? 'Id: Paid via Online Banking - No id Availbale'
                            : 'Paid via wallet - No id available',
                        method: 'Method: ${booking.paymentMethod}',
                        status: booking.status,
                        statusIcon: booking.status.toLowerCase() == 'completed'
                            ? Icons.check_circle_outline_outlined
                            : Icons.timelapse,
                        stusColor: booking.status.toLowerCase() == 'completed'
                            ? AppPalette.greenClr
                            : AppPalette.buttonClr,
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
                            context
                                .read<FetchBookingBloc>()
                                .add(FetchBookingDatsRequest());
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