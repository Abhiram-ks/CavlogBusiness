
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../core/themes/colors.dart';
import '../../../../../../../core/utils/constant/constant.dart';
import '../../../../../domain/usecases/is_slottime_exceeded_usecase.dart';
import '../../../../provider/bloc/booking_generate_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import '../../../../provider/bloc/booking_generate_bloc/modify_slots_generate_bloc/modify_slots_generate_bloc.dart';
import '../../settings_service_management/service_management_filed_widget.dart';
import 'handle_slot_modify_state.dart';

BlocBuilder<FetchSlotsSpecificdateBloc, FetchSlotsSpecificDateState> blocBuilderSlotsPageTwo({required double screenWidth, required double screenHeight}) {
    return BlocBuilder<FetchSlotsSpecificdateBloc, FetchSlotsSpecificDateState>(
        builder: (context, state) {
          if (state is FetchSlotsSpecificDateEmpty) {
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon( Icons.timer_off, color: AppPalette.buttonClr),
                Text( '${state.salectedDate.day}/${state.salectedDate.month}/${state.salectedDate.year}'),
                Text('No slots are available at the moment'),
              ],
            );
          } else if (state is FetchSlotsSpecificDateFailure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.timer_off, color: AppPalette.redClr),
                Text('Unexpected error occurred'),
                Text('${state.errorMessage}. Please try again!'),
              ],
            );
          } else if (state is FetchSlotsSpecificDateLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300] ?? AppPalette.greyClr,
              highlightColor: AppPalette.whiteClr,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row( 
                      children: List.generate(5, (index) {
                        return colorMarker(
                          context: context,
                          hintText: 'Mark Unavailable',
                          markColor: AppPalette.buttonClr,
                        );
                      }),
                    ),
                  ),
                  ConstantWidgets.hight30(context),
                  Column(
                    children: List.generate(5, (index) {
                      return ServiceManagementFiled(
                        context: context,
                        icon: Icons.timer,
                        screenWidth: screenWidth,
                        label: 'avalable',
                        serviceRate: '--:-- AM?PM',
                        deleteAction: () {},
                        updateIcon: CupertinoIcons.circle,
                        updateAction: (value) {},
                      );
                    }),
                  ),
                ],
              ),
            );
          }
          if (state is FetchSlotsSpecificDateLoaded) {
            final slots = state.slots;
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      colorMarker(context: context,hintText: 'Mark Unavailable',markColor: AppPalette.buttonClr),
                      colorMarker(context: context,hintText: 'Mark Available',markColor: AppPalette.greyClr),
                      colorMarker(context: context,hintText: 'Booked',markColor: AppPalette.greenClr),
                      colorMarker(context: context,hintText: 'Time Exceeded',markColor: AppPalette.hintClr),
                    ],
                  ),
                ),
                ConstantWidgets.hight30(context),
                BlocListener<ModifySlotsGenerateBloc, ModifySlotsGenerateState>(
                  listener: (context, state) {
                    handleSlotUpdatesState(context, state);
                  },
                  child: Column(
                    children: slots.map((slot) {
                      String formattedStartTime = formatTimeRange(slot.startTime);
                      String formattedEndTime = formatTimeRange(slot.endTime);
                      final bool isTimeExceeded = isSlotTimeExceeded(slot.docId, formattedStartTime);

                      return ServiceManagementFiled(
                        context: context,
                        icon: Icons.timer,
                        screenWidth: screenWidth,
                        firstIconColor: slot.booked
                            ? AppPalette.greenClr.withAlpha(128)
                            : AppPalette.whiteClr,
                        firstIconBgColor: slot.booked
                            ? AppPalette.trasprentClr
                            : slot.available
                                ? (isTimeExceeded
                                    ? AppPalette.greyClr.withAlpha(50)
                                    : AppPalette.greyClr)
                                : (isTimeExceeded
                                    ? AppPalette.greyClr.withAlpha(50)
                                    : AppPalette.buttonClr),
                        secoundIconColor: slot.booked
                            ? AppPalette.greenClr.withAlpha(128)
                            : (isTimeExceeded
                                ? AppPalette.whiteClr
                                : AppPalette.whiteClr),
                        secoundIconBgColor: slot.booked
                            ? AppPalette.trasprentClr
                            : (isTimeExceeded
                                ? AppPalette.redClr.withAlpha(50)
                                : AppPalette.redClr),
                        label: slot.booked
                            ? 'Booked'
                            : slot.available
                                ? (isTimeExceeded
                                    ? 'Available (Time Exceeded)'
                                    : 'Available')
                                : (isTimeExceeded
                                    ? 'Unavailable (Time Exceeded)'
                                    : 'Unavailable'),
                        serviceRate: "$formattedStartTime - $formattedEndTime",
                        updateDeletIcon: slot.booked
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.delete_solid,
                        updateIcon: slot.booked
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.clear,
                        deleteAction: () {
                          if (slot.booked == false) {
                            context.read<ModifySlotsGenerateBloc>().add(
                                RequestDeleteGeneratedSlotEvent(shopId: slot.shopId,docId: slot.docId,subDocId: slot.subDocId, time: "$formattedStartTime - $formattedEndTime"));
                          }
                        },
                        updateOntap: () {
                          if (slot.booked == false && isTimeExceeded == false) {
                            context.read<ModifySlotsGenerateBloc>().add(
                                ChangeSlotStatusEvent( shopId: slot.shopId,docId: slot.docId,subDocId: slot.subDocId,status: slot.available ? false : true));
                          }
                        },
                        updateAction: (value) {},
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search, color: AppPalette.buttonClr),
              Text('Searching ...'),
              Text('Oops! Something went wrong. Try different date.')
            ],
          );
        },
      );
  }

  

Row colorMarker(
    {required BuildContext context,
    required Color markColor,
    required String hintText}) {
  return Row(children: [
    Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: markColor, shape: BoxShape.rectangle,
        )),
    ConstantWidgets.width20(context),
    Text(hintText),
    ConstantWidgets.width40(context)
  ]);
}