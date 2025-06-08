
import 'package:barber_pannel/cavlog/app/domain/usecases/flutter_direct_phonecall_function.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_pendings_bloc/fetch_pendings_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/bookings_screen/booking_details_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/user_profile_screen/user_profile_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/home_screen_widget/home_screen_horizontalicon_timeline.dart';
import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/themes/colors.dart';

class TimelineBuilderPendings extends StatelessWidget {
  const TimelineBuilderPendings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPendingsBookingBloc, FetchPendingsBookingState>(
      builder: (context, state) {
        if (state is FetchPendingsBookingLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? AppPalette.greyClr,
            highlightColor: AppPalette.whiteClr,
            child: HorizontalIconTimelineHelper(
              screenWidth: MediaQuery.of(context).size.width,
              screenHeight: MediaQuery.of(context).size.height,
              createdAt: DateTime.parse('2025-05-05T15:10:38+05:30'),
              duration: 90,
              bookingId: '',
              slotTimes: [
                DateTime.parse('2025-05-12T08:00:00+05:30'),
                DateTime.parse('2025-05-12T08:45:00+05:30'),
              ],
              onTapInformation: () {},
              onTapCall: () {},
              onSendMail: () {},
              imageUrl: AppImages.loginImageAbove,
              onTapUSer: () {},
              email: 'example@gmail.com',
              userName: 'Masterpiece - The Classic Cut Barbershop',
              address:'123 Kingsway Avenue, Downtown District, Springfield, IL 62704',
            ),
          );
        } else if (state is FetchPendingsBookingEmpty) {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstantWidgets.hight30(context),
                  Icon(Icons.event_busy),
                  Text('No Bookings Yet!',style: TextStyle(color: AppPalette.orengeClr)),
                  Text("No activity found — time to take action!"),
                  ConstantWidgets.hight30(context),
                ]),
          );
        } else if (state is FetchPendingsBookingLoaded) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.combo.length,
            separatorBuilder: (_, __) =>  ConstantWidgets.hight10(context),
            itemBuilder: (context, index) {
              final booking = state.combo[index];
    
              return HorizontalIconTimelineHelper(
                screenWidth: MediaQuery.of(context).size.width,
                screenHeight: MediaQuery.of(context).size.height,
                createdAt: booking.booking.createdAt,
                duration: booking.booking.duration,
                slotTimes: booking.booking.slotTime,
                bookingId: booking.booking.bookingId ?? '',
                email: booking.user.email,
                onTapInformation: () {
                  Navigator.push(
                      context,MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(
                              barberId: booking.booking.barberId,
                              userId: booking.booking.userId,
                              docId:booking.booking.bookingId ?? '')));
                },
                onTapCall: () {
                  if (booking.user.phoneNumber == null) {
                    CustomeSnackBar.show(
                        context: context,
                        title: 'Phone number not available',
                        description: "Unable to make a call at this time. Phone number is not available.",
                        titleClr: AppPalette.redClr);
                    return;
                  } else {
                    CallHelper.makeCall(booking.user.phoneNumber ?? '', context);
                  }
                },
                onSendMail: () async {
                  final Uri emialUri = Uri(
                    scheme: 'mailto',
                    path: booking.user.email,
                    query:'subject=${Uri.encodeComponent("To connect with")}&body=${Uri.encodeComponent("Hello ${booking.user.userName ?? 'Customer'},\n\nI This is 'Shop Name' from Cavalog. I wanted to follow up regarding your recent booking.")}',
                  );
                  try {
                    await launchUrl(emialUri);
                  } catch (e) {
                    if (!context.mounted) return;
                    CustomeSnackBar.show(
                        context: context,
                        title: 'Email not open',
                        description:"Unable to open the email app at this time. Try opening your email manually. Error: $e",
                        titleClr: AppPalette.redClr);
                  }
                },
                imageUrl: booking.user.image ?? AppImages.loginImageAbove,
                onTapUSer: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute( builder: (context) => UserProfileScreen(userId: booking.booking.userId)));
                },
                userName: booking.user.userName ?? 'Unknown user',
                address: booking.user.address ?? 'Unknown Address',
              );
            },
          );
        }
        return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstantWidgets.hight30(context),
                Icon(Icons.event_busy),
                Text('Oops! Something went wrong!',style: TextStyle(color: AppPalette.redClr)),
                Text("We're having trouble processing your request."),
                InkWell(
                    onTap: () async {
                      context.read<FetchPendingsBookingBloc>().add(FetchPendingsBookingRequest());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: AppPalette.blueClr,
                        ),
                        ConstantWidgets.width20(context),
                        Text("Refresh",
                            style: TextStyle(
                                color: AppPalette.blueClr,
                                fontWeight: FontWeight.bold)),
                      ],
                    ))
              ]),
        );
      },
    );
  }
}