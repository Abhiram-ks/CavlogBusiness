
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_users_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_user_profile_widget/user_profile_body_widget.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchUserBloc(FetchUserRepositoryImpl()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
                child: Scaffold(
                    appBar: CustomAppBar(),
                    body: UserProfileBodyWIdget(
                        userId: userId,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight))),
          );
        },
      ),
    );
  }
}
