import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/settings_service_management/service_editandupdate_state_handle.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/settings_service_management/service_management_filed_widget.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/bloc/modifications/barber_service_modification_bloc/barber_service_modeification_bloc.dart';
import '../../../provider/bloc/fetchings/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';

class BarberServiceBuilderWIdget extends StatelessWidget {
  const BarberServiceBuilderWIdget({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberServiceBloc, FetchBarberServiceState>(
      builder: (context, state) {
        if (state is FetchBarberServiceLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(
                  radius: 16.0,
                ),
                ConstantWidgets.hight10(context),
                Text('Just a moment...'),
                Text('Please wait while we process your request'),
              ],
            ),
          );
        } else if (State is FetchBarberServiceEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.cloud_download_fill),
                ConstantWidgets.hight10(context),
                Text("Oops! There's nothing here yet."),
                Text('No services added yet — time to take action!'),
              ],
            ),
          );
        }
        if (state is FetchBarberServiceSuccess) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Management',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      ConstantWidgets.hight10(context),
                      const Text(
                          'Craft your perfect service lineup — add, update, or fine-tune offerings to match your brand’s style.'),
                      ConstantWidgets.hight30(context),
                    ],
                  ),
                ),
                BlocListener<BarberServiceModeificationBloc,
                    BarberServiceModeificationState>(
                  listener: (context, state) {
                    handleServiceEditAndUpdaTeState(context, state);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15 : screenWidth * 0.08),
                    child: Column(
                      children: state.services.map((service) {
                        return ServiceManagementFiled(
                          context: context,
                          screenWidth: screenWidth,
                          icon: Icons.currency_rupee_sharp,
                          label: service.serviceName,
                          serviceRate: service.amount.toStringAsFixed(0),
                          deleteAction: () {
                            context.read<BarberServiceModeificationBloc>().add(
                                FetchBarberServicDeleteRequestEvent(
                                    barberUid: service.barberId,
                                    serviceKey: service.serviceName));
                          },
                          updateAction: (value) {
                            context.read<BarberServiceModeificationBloc>().add(
                                  FetchBarberServiceUpdateRequestEvent(
                                    barberUid: service.barberId,
                                    serviceKey: service.serviceName,
                                    serviceValue: value,
                                    oldServiceValue: service.amount,
                                  ),
                                );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.cloud_download_fill),
              Text("Oop's Unable to complete the request."),
              Text('Please try again later.'),
            ],
          ),
        );
      },
    );
  }
}
