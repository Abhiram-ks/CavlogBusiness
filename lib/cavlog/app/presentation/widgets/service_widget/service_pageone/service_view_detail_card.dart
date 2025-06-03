
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/pdf_maker_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_widget_upload_datas.dart';
import 'package:barber_pannel/core/common/common_action_button.dart';
import 'package:barber_pannel/core/common/common_loading_widget.dart';
import 'package:barber_pannel/core/common/snackbar_helper.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/themes/colors.dart';

class ViewServiceDetailsPage extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const ViewServiceDetailsPage(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBarberBloc>().add(FetchCurrentBarber());
    });
    return BlocBuilder<FetchBarberBloc, FetchBarberState>(
      builder: (context, state) {
        if (state is FetchBarbeLoading || state is FetchBarberError) {
          return LoadingScreen(
              screenHeight: screenHeight, screenWidth: screenWidth);
        } else if (state is FetchBarberLoaded) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barber Details',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  ConstantWidgets.hight10(context),
                  Text(
                      "Please provide complete details of your barber shop. The generated BarberDocs will compile all submitted information, serving as an official reference for service management and business documentation."),
                  ConstantWidgets.hight20(context),
                  UploadingServiceDatas(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      barber: state.barber),
                  ConstantWidgets.hight10(context),
                  ActionButton(
                    color: AppPalette.redClr,
                    screenWidth: screenWidth,
                    screenHight: screenHeight,
                    label: 'BarberDocs',
                    onTap: () async {
                      final success = await PdfMakerWidget.generateDetails(
                          barberName: state.barber.barberName,
                          ventureName: state.barber.ventureName,
                          phoneNumber: state.barber.phoneNumber,
                          address: state.barber.address,
                          email: state.barber.email,
                          establishedYear: state.barber.age,
                          gender: state.barber.gender,
                          status: state.barber.isblok ? 'Blocked' : 'Active');

                      if (success == false) {
                        CustomeSnackBar.show(
                          // ignore: use_build_context_synchronously
                          context: context,
                          title: 'Unable to Open Docs',
                          description:
                              'Oops! Unable to open the Barber Data doc. Please try again later.',
                          titleClr: AppPalette.redClr,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }
        return LoadingScreen(
            screenHeight: screenHeight, screenWidth: screenWidth);
      },
    );
  }
}
