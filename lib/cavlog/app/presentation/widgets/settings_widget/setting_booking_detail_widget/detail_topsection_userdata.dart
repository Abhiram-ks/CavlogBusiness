import 'dart:ui';

import 'package:barber_pannel/cavlog/app/presentation/screens/settings/user_profile_screen/user_profile_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_customs_cards_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_top_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/image/app_images.dart';
import '../../../provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';

class TopPortionWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  const TopPortionWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      child: Center(child:
          BlocBuilder<FetchUserBloc, FetchUserState>(builder: (context, state) {
        if (state is FetchUserLoaded) {
          final user = state.users;
          return ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    height: screenHeight * 0.13,
                    width: screenWidth * 0.77,
                    color: AppPalette.blackClr.withAlpha((0.27 * 255).toInt()),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserProfileScreen(userId: user.uid)));
                      },
                      child: paymentSectionBarberData(
                          context: context,
                          imageURl: user.image ?? AppImages.emptyImage,
                          shopName: user.userName ?? 'Name not available',
                          shopAddress: user.address ?? 'No address information available at this time',
                          email: user.email,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                    ),
                  )));
        }
        return Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? AppPalette.greyClr,
            highlightColor: AppPalette.whiteClr,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    height: screenHeight * 0.13,
                    width: screenWidth * 0.77,
                    color: AppPalette.hintClr.withAlpha((0.5 * 255).toInt()),
                    alignment: Alignment.center,
                    child: paymentSectionBarberData(
                        context: context,
                        imageURl: AppImages.emptyImage,
                        shopName: 'Name not available',
                        shopAddress: 'No address information available at this time',
                        email: 'userxyz@gmail.com',
                        screenHeight: screenHeight,
                        screenWidth: screenWidth),
                  ),
                )));
      })),
    );
  }
}
