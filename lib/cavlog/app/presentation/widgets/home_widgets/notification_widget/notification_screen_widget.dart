import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/notification_widget/notification_builder_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/home_widgets/notification_widget/notification_count_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifcationScreenWidget extends StatefulWidget {
  const NotifcationScreenWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  final double screenWidth;
  final double screenHeight;

  @override
  State<NotifcationScreenWidget> createState() =>
      _NotifcationScreenWidgetState();
}

class _NotifcationScreenWidgetState extends State<NotifcationScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchBookingWithBarberBloc>()
          .add(FetchBookingWithUserFileterRequest(filtering: 'Pending'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notifications',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: widget.screenHeight * 0.02),
              Text(
                'Stay updated with important booking alerts, including pending and confirmed appointments.',
              ),
            ],
          ),
        ),
        BookingCountWidget(
          screenWidth: widget.screenHeight,
          screenHeight: widget.screenHeight,
        ),
        Expanded(
            child: notificationWidgetBuilder(
                context, widget.screenHeight, widget.screenHeight)),
      ],
    );
  }
}
