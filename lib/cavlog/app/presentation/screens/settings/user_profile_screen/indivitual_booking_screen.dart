import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/common/custom_app_bar.dart';
import '../../../../../../core/common/lottie_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../../core/utils/image/app_images.dart';
import '../../../provider/bloc/fetchings/fetch_booking_user/fetch_booking_user_bloc.dart';
import '../../../widgets/home_widgets/wallet_widget/wallet_tranasction_card_widget.dart';
import '../../../widgets/settings_widget/setting_booking_management/booking_filter_custom_cards.dart';
import '../../../widgets/settings_widget/setting_indivitul_booking_widget/indivitual_booking_body_widget.dart';
import '../bookings_screen/booking_details_screen.dart';

class IndivitualBookingScreen extends StatelessWidget {
  final String userId;
  const IndivitualBookingScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchBookingUserBloc(
        FetchBookingUserRepositoryImpl(),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                  appBar: CustomAppBar(),
                  body: IndivitualBookingBodyWidget(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    userId: userId,
                  )),
            ),
          );
        },
      ),
    );
  }
}

