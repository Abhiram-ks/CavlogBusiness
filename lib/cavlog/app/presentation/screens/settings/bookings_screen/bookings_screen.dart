import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/custom_app_bar.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../data/repositories/fetch_booking_with_user_repo.dart';
import '../../../../data/repositories/fetch_users_repo.dart';
import '../../../provider/bloc/fetchings/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import '../../../widgets/settings_widget/setting_booking_management/booking_body_widget.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchBookingWithBarberBloc(
        FetchBookingWithUserRepositoryImpl(
          UserServices(
            FetchUserRepositoryImpl(),
          ),
        ),
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
                  body: BookingScreenWidget(
                      screenWidth: screenWidth, screenHeight: screenHeight)),
            ),
          );
        },
      ),
    );
  }
}
