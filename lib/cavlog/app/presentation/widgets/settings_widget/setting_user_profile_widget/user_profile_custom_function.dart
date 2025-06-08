
import 'package:barber_pannel/cavlog/app/data/models/user_model.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/flutter_direct_phonecall_function.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/chat/indivitualchat_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/user_profile_screen/indivitual_booking_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_customs_cards_widget.dart';
import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Padding customerFunctions(
    {required BuildContext context,
    required double screenWidth,
    required String barberID,
    required UserModel user}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        detailsPageActions(
            context: context,
            screenWidth: screenWidth,
            icon: CupertinoIcons.chat_bubble_2_fill,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualChatScreen(userId: user.uid, barberId:barberID)));
            },
            text: 'Message'),
        detailsPageActions(
            context: context,
            screenWidth: screenWidth,
            icon: Icons.phone_in_talk_rounded,
            onTap: () {
              if (user.phoneNumber == null) {
                CustomeSnackBar.show(
                    context: context,
                    title: 'Phone number not available',
                    description:"Unable to make a call at this time. Phone number is not available.",
                    titleClr: AppPalette.redClr);
                return;
              }
               else {
                 CallHelper.makeCall(user.phoneNumber ?? '', context);
              }
             
            },
            text: 'Call'),
        detailsPageActions(
            context: context,
            screenWidth: screenWidth,
            icon: Icons.attach_email,
            onTap: () async {
              final Uri emialUri = Uri(
                scheme: 'mailto',
                path: user.email,
                query:'subject=${Uri.encodeComponent("To connect with")}&body=${Uri.encodeComponent("Hello ${user.userName ?? 'Customer'},\n\nI This is 'Shop Name' from Cavalog. I wanted to follow up regarding your recent booking.")}',
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
            text: 'Email'),
        detailsPageActions(
          context: context,
          colors: const Color(0xFFFEBA43),
          screenWidth: screenWidth,
          icon: CupertinoIcons.calendar,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => IndivitualBookingScreen(userId: user.uid),));
          },
          text: 'Bookings',
        )
      ],
    ),
  );
}
