
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barber_slot_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/slot_update_generated_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/booking_generate_bloc/generate_slot_bloc/generate_slot_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/booking_generate_bloc/modify_slots_generate_bloc/modify_slots_generate_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/booking_generate_cubit/duration_picker/duration_picker_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/booking_generate_cubit/slote_delete_privious_bloc/slot_delete_privious_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/booking_generate_cubit/time_picker/time_picker_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/edit_mode/edit_mode_cubit.dart';
import 'package:barber_pannel/core/common/common_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/custom_app_bar.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../data/datasources/slot_remote_datasource.dart';
import '../../../provider/bloc/booking_generate_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_slots_dates_bloc/fetch_slots_dates_bloc.dart';
import '../../../provider/cubit/booking_generate_cubit/calender_picker/calender_picker_cubit.dart';
import '../../../provider/cubit/current_service_cubit/current_service_cubit.dart';
import '../../../widgets/settings_widget/setting_time_management/pageone_settings_time_management/settings_time_management_pageone_widget.dart';
import '../../../widgets/settings_widget/setting_time_management/pagetwo_settings_time_management/settings_time_management_pagetwo_widget.dart';

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  State<TimeManagementScreen> createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> {
  @override
  void initState() {
    super.initState();
    _deleteOldSlots();
  }

  Future<void> _deleteOldSlots() async {
    await context.read<SlotDeletePriviousCubit>().deleteOldSlots();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalenderPickerCubit()),
        BlocProvider(create: (_) => TimePickerCubit()),
        BlocProvider(create: (_) => EditModeCubit()),
        BlocProvider(create: (_) => DurationPickerCubit()),
        BlocProvider(create: (_) => ServicePageCubit()),
        BlocProvider(create: (_) => GenerateSlotBloc(SlotRepositoryImpl())),
        BlocProvider(create: (_) => FetchSlotsDatesBloc(FetchSlotsRepositoryImpl())),
        BlocProvider(create: (_) => FetchSlotsSpecificdateBloc(FetchSlotsRepositoryImpl())),
        BlocProvider(create: (_) => ModifySlotsGenerateBloc(SlotUpdateRepositoryImpl()))
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                  appBar: CustomAppBar(),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: BlocBuilder<ServicePageCubit, CurrentServicePage>(
                      builder: (context, state) {
                        switch (state) {
                         /*--------------------------------------------
                          Call for the generated slots session part & 
                          manage the display of generated slots through 
                          appropriate widgets and handlers.
                        ---------------------------------------------*/

                          case CurrentServicePage.pageOne:
                            return TimeManagementPageOne(screenWidth: screenWidth,screenHeight: screenHeight);
                          case CurrentServicePage.pageTwo:
                            return TimeManagementPageTwo(screenWidth: screenWidth,screenHeight: screenHeight);
                        }
                      },
                    ),
                  ),
                  floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: SizedBox(
                    width: screenWidth * .9,
                    child: BlocBuilder<ServicePageCubit, CurrentServicePage>(
                      builder: (context, state) {
                        final isPageOne = state == CurrentServicePage.pageOne;
                        return ActionButton(
                          hasBorder: true,
                          textColor: isPageOne
                              ? AppPalette.buttonClr
                              : AppPalette.whiteClr,
                          borderColor: AppPalette.buttonClr,
                          color: isPageOne
                              ? AppPalette.trasprentClr
                              : AppPalette.buttonClr,
                          screenWidth: screenWidth,
                          screenHight: screenHeight,
                          onTap: () {
                            isPageOne
                                ? context.read<ServicePageCubit>().goToPageTwo()
                                : context.read<ServicePageCubit>().goToPageOne();
                          },
                          label: isPageOne ? 'View Slots' : 'Back to Generator',
                        );
                      },
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}



