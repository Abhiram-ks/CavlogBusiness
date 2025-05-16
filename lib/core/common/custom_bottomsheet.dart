import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cavlog/auth/presentation/provider/cubit/buttonProgress/button_progress_cubit.dart';

class BottomSheetHelper {
  void showBottomSheet({
    required BuildContext context,
    required String title,
    required String description,
    required String firstButtonText,
    required VoidCallback firstButtonAction,
    required Color firstButtonColor,
    required String secondButtonText,
    required VoidCallback secondButtonAction,
    required Color secondButtonColor,
     Color progressClr = AppPalette.blackClr,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppPalette.whiteClr,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantWidgets.hight20(context),
              Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
               ConstantWidgets.hight20(context),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: TextButton(
                          onPressed: secondButtonAction,
                          child: Text(
                            secondButtonText,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              color: secondButtonColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      child: VerticalDivider(
                        color:AppPalette.greyClr,
                      ),
                    ),
                     Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: TextButton(
                          onPressed: firstButtonAction,
                          child: BlocBuilder<ButtonProgressCubit, ButtonProgressState>(
                            builder: (context, state) {
                              if (state is BottomSheetButtonLoading) {
                                return  SpinKitFadingFour(
                                color:progressClr,
                                   size: 23.0,
                                );
                              }
                              return Text(
                                firstButtonText,
                                style: GoogleFonts.inter(
                                  fontSize: 17,
                                  color: firstButtonColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ConstantWidgets.hight20(context)
            ],
          ),
        );
      },
    );
  }
}
