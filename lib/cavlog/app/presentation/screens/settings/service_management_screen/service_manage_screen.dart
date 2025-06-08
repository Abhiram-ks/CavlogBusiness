import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/settings_service_management/barber_service_builder_widget.dart';
import 'package:barber_pannel/core/common/common_action_button.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/fetch_barber_service_repo.dart';
import '../../../provider/bloc/modifications/barber_service_modification_bloc/barber_service_modeification_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import '../../../provider/cubit/edit_mode/edit_mode_cubit.dart';

class ServiceManageScreen extends StatelessWidget {
  const ServiceManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => FetchBarberServiceBloc(
                repository: FetchBarberServiceRepositoryImpl())
              ..add(FetchBarberServiceRequestEvent())),
        BlocProvider(create: (context) => EditModeCubit()),
        BlocProvider(
            create: (context) => BarberServiceModeificationBloc(
                FetchBarberServiceRepositoryImpl()))
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Scaffold(
                  appBar: CustomAppBar(
                    text: 'Edit',
                    iconColor: AppPalette.blackClr,
                    onPressed: () =>  context.read<EditModeCubit>().toggleEditMode(),
                  ),
                  body: BarberServiceBuilderWIdget(screenWidth: screenWidth),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: SizedBox(
                    width: screenWidth * .9,
                    child: ActionButton(
                      screenWidth: screenWidth,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.serviceAddscreen),
                      label: 'Add service',
                      screenHight: screenHeight,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
