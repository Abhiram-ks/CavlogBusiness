
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/user_profile_screen/user_profile_screen.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final double screenWidth;

  const ChatAppBar({
    super.key,
    required this.userId,
    required this.screenWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    context.read<FetchUserBloc>().add(FetchUserRequest(userID:userId));

    return BlocBuilder<FetchUserBloc, FetchUserState>(
      builder: (context, state) {
         if (state is FetchUserLoaded) {
          final user = state.users;

          return AppBar(
            backgroundColor: AppPalette.blackClr,
            automaticallyImplyLeading: true,
            elevation: 0,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: AppPalette.whiteClr),
            title: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(userId: userId))),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl: user.image ?? '',
                        imageAsset: AppImages.loginImageAbove,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userName ?? 'Unknown Name' ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppPalette.whiteClr,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                              fontSize: 16,
                            color:AppPalette.hintClr ,
                          ),
                        ),
                      ],
                    ),
                  ),
                    ConstantWidgets.width40(context),
                ],
              ),
            ),
          );
        } return  AppBar(
            backgroundColor: AppPalette.blackClr,
            automaticallyImplyLeading: true,
            elevation: 0,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: AppPalette.whiteClr),
            title: Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
          highlightColor: AppPalette.whiteClr,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl:'',
                        imageAsset: AppImages.loginImageAbove,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Name Loading..." ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontSize: 16,
                            color: AppPalette.whiteClr,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                         'Loading...',
                          style: TextStyle(
                              fontSize: 16,
                            color:AppPalette.hintClr ,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
