
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_customs_cards_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_user_profile_widget/user_profile_custom_function.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/image/app_images.dart';

class UserProfileBodyWIdget extends StatefulWidget {
  const UserProfileBodyWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
  });

  final double screenWidth;
  final double screenHeight;
  final String userId;

  @override
  State<UserProfileBodyWIdget> createState() => _UserProfileBodyWIdgetState();
}

class _UserProfileBodyWIdgetState extends State<UserProfileBodyWIdget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchUserBloc>().add(FetchUserRequest(userID: widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchUserBloc, FetchUserState>(
      builder: (context, state) {
        if (state is FatchUserLoading) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppPalette.buttonClr),
              ConstantWidgets.hight20(context),
              Text('Loading...')
            ],
          ));
        } else if (state is FetchUserLoaded) {
          final user = state.users;
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *.15 : widget.screenWidth * 0.05),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Dashboard',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  ConstantWidgets.hight10(context),
                  Text(
                    'Access essential client details and build stronger connections through seamless chat and contact features.',
                  ),
                  ConstantWidgets.hight20(context),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          color: AppPalette.greyClr,
                          width: 60,
                          height: 60,
                          child: user.image != null &&
                                  user.image!.startsWith('http')
                              ? imageshow(
                                  imageUrl: user.image!,
                                  imageAsset: AppImages.loginImageAbove)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    AppImages.loginImageAbove,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      ConstantWidgets.width20(context),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.verified,
                            user.email,
                            textColor: AppPalette.greyClr,
                            AppPalette.blueClr,
                          ),
                        ],
                      ),
                    ],
                  ),
                  ConstantWidgets.hight20(context),
                  Text('Personal Info',style: TextStyle(color: AppPalette.greyClr)),
                  ConstantWidgets.hight20(context),
                  Text('Full Name', style: TextStyle(color: AppPalette.buttonClr)),
                  Text(user.userName ?? "We're unable to display the name at this time.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstantWidgets.hight20(context),
                  Text('Address',style: TextStyle(color: AppPalette.buttonClr)),
                  Text(user.address ?? "We're unable to display the address at this time.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstantWidgets.hight10(context),
                  Text('Age', style: TextStyle(color: AppPalette.buttonClr)),
                  Text(
                    user.age != null
                        ? '${user.age} years old'
                        : "We're unable to display the age at this time.",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstantWidgets.hight20(context),
                  Text('Communication & History',
                      style: TextStyle(color: AppPalette.greyClr)),
                  ConstantWidgets.hight20(context),
                  customerFunctions(
                      context: context,
                      screenWidth: widget.screenWidth,
                      barberID: state.barberId,
                      user: user),
                  ConstantWidgets.hight20(context),
                ],
              ),
            ),
          );
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.person),
            Text("We're unable to process your request at the moment."),
            Text('Try again later'),
            IconButton(
                onPressed: () {
                  context.read<FetchUserBloc>().add(FetchUserRequest(userID: widget.userId));
                },
                icon: Icon(CupertinoIcons.refresh)),
          ],
        ));
      },
    );
  }
}
