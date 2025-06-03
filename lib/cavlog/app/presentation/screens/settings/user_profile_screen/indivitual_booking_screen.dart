import 'package:barber_pannel/cavlog/app/data/repositories/fetch_booking_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/custom_app_bar.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../provider/bloc/fetchings/fetch_booking_user/fetch_booking_user_bloc.dart';
import '../../../widgets/settings_widget/setting_indivitul_booking_widget/indivitual_booking_body_widget.dart';

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

