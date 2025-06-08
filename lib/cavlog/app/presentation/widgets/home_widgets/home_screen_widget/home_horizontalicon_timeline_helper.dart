
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/auto_complited_booking_cubit/auto_complited_booking_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/booking_timeline_cubit/booking_timeline_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/booking_timeline_cubit/booking_timeline_state.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_customs_cards_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_top_card_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalIconTimeline extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTapInformation;
  final VoidCallback onTapCall;
  final VoidCallback onSendMail;
  final String imageUrl;
  final String bookingId;
  final VoidCallback onTapUSer;
  final String userName;
  final String email;
  final String address;
  final DateTime createdAt;
  final List<DateTime> slotTimes;
  final int duration;

  const HorizontalIconTimeline(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.onTapInformation,
      required this.onTapCall,
      required this.onSendMail,
      required this.imageUrl,
      required this.onTapUSer,
      required this.userName,
      required this.email,
      required this.address,
      required this.createdAt,
      required this.slotTimes,
      required this.duration,
      required this.bookingId});

  @override
  State<HorizontalIconTimeline> createState() => _HorizontalIconTimelineState();
}

class _HorizontalIconTimelineState extends State<HorizontalIconTimeline> {
  final List<IconData> icons = [
    Icons.event,
    Icons.timer_outlined,
    Icons.cut_outlined,
    Icons.verified,
  ];

  final List<String> labels = [
    'Booked',
    'waiting',
    'InProgress',
    'Finished',
  ];

  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().updateTimeline(
          createdAt: widget.createdAt,
          slotTimes: widget.slotTimes,
          duration: widget.duration,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.hintClr)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<TimelineCubit, TimelineState>(
            builder: (context, state) {
              int currentStep = 0;
              switch (state.currentStep) {
                case TimelineStep.created:
                  currentStep = 0;
                  break;
                case TimelineStep.waiting:
                  currentStep = 1;
                  break;
                case TimelineStep.inProgress:
                  currentStep = 2;
                  break;
                case TimelineStep.completed:
                  currentStep = 3;
                  final sortedSlotTimes = List<DateTime>.from(widget.slotTimes)..sort();

                  final endTime = sortedSlotTimes.last;
                  if (DateTime.now().isAfter(endTime)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<AutoComplitedBookingCubit>().completeBooking(
                            widget.bookingId,
                          );
                    });
                  }
                  break;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(icons.length, (index) {
                      final isActive = index <= currentStep;
                      Color iconColor =  isActive ? AppPalette.blackClr : AppPalette.greyClr;

                      return Expanded(
                        child: Column(
                          children: [
                            Icon(icons[index], color: iconColor),
                            ConstantWidgets.hight10(context),
                            Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  ConstantWidgets.hight10(context),
                  Row(
                    children: List.generate(icons.length * 2 - 1, (index) {
                      if (index % 2 == 0) {
                        final stepIndex = index ~/ 2;
                        final isActive = stepIndex <= currentStep;
                        final isCurrentStep = stepIndex == currentStep;

                        return Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppPalette.orengeClr
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: isCurrentStep
                                ? Border.all(
                                    color: AppPalette.buttonClr, width: 2)
                                : null,
                          ),
                          child: Center(
                              child: isCurrentStep
                                  ? CircularProgressIndicator(
                                      color: AppPalette.orengeClr,
                                    )
                                  : null),
                        );
                      } else {
                        final lineIndex = index ~/ 2;
                        final isActive = lineIndex < currentStep;

                        return Expanded(
                          child: Container(
                            height: 3,
                            color: isActive
                                ? AppPalette.buttonClr
                                : Colors.grey.shade300,
                          ),
                        );
                      }
                    }),
                  ),
                ],
              );
            },
          ),
          ConstantWidgets.hight10(context),
          InkWell(
            onTap: widget.onTapUSer,
            child: paymentSectionBarberData(
                addressColor: AppPalette.greyClr,
                textColor: AppPalette.blackClr,
                context: context,
                imageURl: widget.imageUrl,
                shopName: widget.userName,
                shopAddress: widget.address,
                email: widget.email,
                screenHeight: widget.screenHeight,
                screenWidth: widget.screenWidth),
          ),
          ConstantWidgets.hight10(context),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: CupertinoIcons.info_circle_fill,
                onTap: widget.onTapInformation,
                text: 'Details',
              ),
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: Icons.phone_in_talk_rounded,
                onTap: widget.onTapCall,
                text: 'Call',
              ),
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: Icons.attach_email_rounded,
                onTap: widget.onSendMail,
                text: 'Email',
              ),
              if (context.read<TimelineCubit>().state.currentStep ==
                  TimelineStep.inProgress)
                detailsPageActions(
                  context: context,
                  colors: AppPalette.greenClr,
                  screenWidth: widget.screenWidth,
                  icon: Icons.check_circle_sharp,
                  onTap: () {
                    context.read<AutoComplitedBookingCubit>().completeBooking(
                          widget.bookingId,
                        );
                  },
                  text: 'Complete',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
