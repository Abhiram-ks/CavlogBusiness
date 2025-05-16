
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_bottom_portion_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_topsection_userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../provider/bloc/fetchings/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';

class BookingDetailBodyWidget extends StatefulWidget {
  const BookingDetailBodyWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barberId,
    required this.userId,
    required this.docId,
  });

  final double screenHeight;
  final double screenWidth;
  final String userId;
  final String docId;
  final String barberId;

  @override
  State<BookingDetailBodyWidget> createState() =>
      _BookingDetailBodyWidgetState();
}

class _BookingDetailBodyWidgetState extends State<BookingDetailBodyWidget> {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchUserBloc>().add(FetchUserRequest(userID: widget.userId));
       context.read<FetchSpecificBookingBloc>().add(FetchSpecificBookingRequest(docId: widget.docId));
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ColoredBox(
        color: AppPalette.orengeClr,
        child: SafeArea(
            child: Column(
          children: [
            TopPortionWidget(
              screenHeight: widget.screenHeight,
              screenWidth: widget.screenWidth,
              userId: widget.userId,
            ),
            BookingDetailsBottomDetails(screenHeight: widget.screenHeight, screenWidth:widget.screenWidth)
          ],
        )),
      ),
    );
  }
}


