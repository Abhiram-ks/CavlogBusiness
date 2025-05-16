import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_portion_widget.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/booking_model.dart' show BookingModel;

class MyBookingDetailsScreenListsWidget extends StatelessWidget {
  final double screenWidth;
  final BookingModel model;
  final double screenHight;
  const MyBookingDetailsScreenListsWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
     final isOnline = model.paymentMethod.toLowerCase().contains('online banking');
    final double totalServiceAmount = model.serviceType.values.fold(0.0, (sum, value) => sum + value);
    return MyBookingDetailsPortionWidget(screenWidth: screenWidth, screenHight: screenHight, model: model, isOnline: isOnline, amount: totalServiceAmount);
  }
}



