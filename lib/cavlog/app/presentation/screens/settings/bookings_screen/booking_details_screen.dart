import 'package:barber_pannel/cavlog/app/data/repositories/fetch_specific_booking_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_users_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../provider/bloc/fetchings/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
class BookingDetailsScreen extends StatelessWidget {
  final String barberId;
  final String userId;
  final String docId;
  const BookingDetailsScreen(
      {super.key,
      required this.barberId,
      required this.userId,
      required this.docId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchUserBloc(FetchUserRepositoryImpl())),
        BlocProvider(create: (context) => FetchSpecificBookingBloc(FetchSpecificBookingRepositoryImpl())),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return Scaffold(
          backgroundColor: AppPalette.whiteClr,
          body: BookingDetailBodyWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              userId: userId,
              docId: docId,
              barberId: barberId),
        );
      }),
    );
  }
}
