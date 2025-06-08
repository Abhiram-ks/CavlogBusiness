

import 'package:barber_pannel/cavlog/app/domain/usecases/feedback_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/logout/logout_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/help_screen/help_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/settings_logout_handle/logout_state_handle.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/settings_custom_fileds_widget/settings_custom_widget.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';

class TabbarSettings extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const TabbarSettings({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidgets.hight20(context),
            Text('Settings & privacy',
                style: TextStyle(
                  color: AppPalette.blackClr,
                )),
            Text('Your account',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.profile_circled,
                title: 'Profile details',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.accountScreen,
                      arguments: false);
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.square_pencil,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.accountScreen,
                      arguments: true);
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.lock,
                title: 'Change Password',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.resetPassword,
                      arguments: false);
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.wrench,
                title: 'Service Management',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.serviceManageScreen);
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.clock,
                title: 'Time Management',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.timeManagementScreen);
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.calendar_circle,
                title: 'Booking Management',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.bookingScreen);
                }),
            Divider(color: AppPalette.hintClr),
            ConstantWidgets.hight10(context),
            Text('Community support',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.question_circle,
                title: 'Help',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder:(context) =>  HelpScreen()));
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.bubble_left,
                title: 'Feedback',
                onTap: () {
                  sendFeedback();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.star,
                title: 'Rate app',
                onTap: () {}),
            Divider(
              color: AppPalette.hintClr,
            ),
            ConstantWidgets.hight10(context),
            Text('Legal policies',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.doc,
                title: 'Terms & Conditions',
                onTap: () {
                  termsAndConditionsUrl();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.shield,
                title: 'Privacy Policy',
                onTap: () {
                  privacyPolicyUrl();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: Icons.compare_arrows,
                title: 'Cookies Policy',
                onTap: () {
                  cookiesPolicyUrl();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: Icons.rotate_left_rounded,
                title: 'Service & Refund Policy',
                onTap: () {
                  refundPolicy();
                }),
            Divider(
              color: AppPalette.hintClr,
            ),
            ConstantWidgets.hight10(context),
            Text('Login',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            ConstantWidgets.hight20(context),
            Builder(
              builder: (context) {
                return BlocProvider(
                  create: (context) => LogoutBloc(),
                  child: BlocListener<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      handleLogOutState(context, state);
                    },
                    child: Builder(
                      builder: (innerContext) {
                        return InkWell(
                          splashColor: AppPalette.trasprentClr,
                          child: Text(
                            'Log out',
                            style: TextStyle(
                                color: AppPalette.logoutClr, fontSize: 17),
                          ),
                          onTap: () {
                            BlocProvider.of<LogoutBloc>(innerContext)
                                .add(LogoutActionEvent());
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            ConstantWidgets.hight50(context)
          ],
        ),
      ),
    );
  }
}

Future<void> privacyPolicyUrl() async {
  final Uri termsUrl = Uri.parse(
      'https://www.freeprivacypolicy.com/live/c8b15acc-bf43-4cd7-99e1-ab61baf302b6');
  if (!await launchUrl(
    termsUrl,
    mode: LaunchMode.inAppWebView,
  )) {
    throw 'Could not launch $termsUrl';
  }
}

Future<void> termsAndConditionsUrl() async {
  final Uri termsUrl = Uri.parse(
      'https://www.freeprivacypolicy.com/live/72716f57-9a59-4148-988f-1f3028688650');
  if (!await launchUrl(
    termsUrl,
    mode: LaunchMode.inAppWebView,
  )) {
    throw 'Could not launch $termsUrl';
  }
}

Future<void> refundPolicy() async {
  final Uri termsUrl = Uri.parse(
      'https://www.freeprivacypolicy.com/live/04cb3257-774f-4004-8946-0ed8ba6266f9');

  if (!await launchUrl(
    termsUrl,
    mode: LaunchMode.inAppWebView,
  )) {
    throw 'Could not launch $termsUrl';
  }
}

Future<void> cookiesPolicyUrl() async {
  final Uri termsUrl = Uri.parse(
      'https://www.freeprivacypolicy.com/live/fb8cd1d2-f768-403e-905a-78ca19ef00bd');

  if (!await launchUrl(
    termsUrl,
    mode: LaunchMode.inAppWebView,
  )) {
    throw 'Could not launch $termsUrl';
  }
}
