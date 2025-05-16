import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_booking_datas_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';

class BookingDetailsBottomDetails extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const BookingDetailsBottomDetails({super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<FetchSpecificBookingBloc, FetchSpecificBookingState>(
      builder: (context, state) {
        if (state is FetchSpecificBookingLoading) {
          return  Center(child: CircularProgressIndicator(color: AppPalette.orengeClr,));
        } 
       else if (state is FetchSpecificBookingLoaded) {
          return MyBookingDetailsScreenListsWidget(
            screenHight: screenHeight,
            screenWidth: screenWidth,
            model: state.booking,
          );
       } 
          return Container(
             width: screenWidth,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppPalette.whiteClr),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstantWidgets.hight50(context),
              Icon(CupertinoIcons.calendar_badge_minus),
              Text('Something went wrong while processing booking request.'),
              Text( 'Please try again later.',style: TextStyle(color: AppPalette.redClr),),
              ConstantWidgets.hight20(context),
            ],
          ),
          );
        
      },
    );
  }
}




