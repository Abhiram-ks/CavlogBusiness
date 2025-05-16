
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_time_management/pagetwo_settings_time_management/setting_slot_builder_pagetwo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/utils/constant/constant.dart';
import '../../../../provider/bloc/booking_generate_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import '../../../../provider/cubit/booking_generate_cubit/calender_picker/calender_picker_cubit.dart';
import 'settings_page_two_calender.dart' show pageTwoCalenderPicker;

class TimeManagementPageTwo extends StatefulWidget {
  const TimeManagementPageTwo({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<TimeManagementPageTwo> createState() => _TimeManagementPageTwoState();
}

class _TimeManagementPageTwoState extends State<TimeManagementPageTwo> {
  @override
  void initState() {
    super.initState();
    _fetchSlotsForToday();
  }

  void _fetchSlotsForToday() {
    final selectedDate = context.read<CalenderPickerCubit>().state.selectedDate;
    context.read<FetchSlotsSpecificdateBloc>().add( FetchSlotsSpecificdateRequst(selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*--------------------------------------------
       Page Two – Calendar Picker Widget
      --------------------------------------------*/
      pageTwoCalenderPicker(),
      ConstantWidgets.hight30(context),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.08),
        child: blocBuilderSlotsPageTwo(screenHeight: widget.screenHeight, screenWidth: widget.screenWidth),
      ),
      ConstantWidgets.hight50(context),
    ]);
  }



}