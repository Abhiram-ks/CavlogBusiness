import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:barber_pannel/cavlog/auth/presentation/provider/bloc/splash/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/themes/colors.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if(state is GoToHomePage){
          Navigator.pushReplacementNamed(context,AppRoutes.home);
        }else if(state is GoToLoginPage){
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 170,
                height: 170,
                child: Image.asset(
                  AppImages.splashImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ConstantWidgets.hight20(context),
            BlocBuilder<SplashBloc, SplashState>(
              builder: (context, state) {
                double animationValue = 0.0;

                if (state is SplashAnimating) {
                  animationValue = state.animationValue;
                }
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                       colors: [AppPalette.whiteClr, AppPalette.blackClr],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [animationValue, animationValue + 0.3],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'C Λ V L O G ',
                    style: GoogleFonts.poppins(
                      color: AppPalette.whiteClr,
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              },
            ),
              Text(
              'Innovate, Execute, Succeed',
              style: GoogleFonts.poppins(
                color: AppPalette.greyClr,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        );
      },
    );
  }
}
