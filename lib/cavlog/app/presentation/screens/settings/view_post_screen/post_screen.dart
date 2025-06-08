import 'package:barber_pannel/cavlog/app/data/repositories/fetch_post_with_barber_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_postwith_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/like_comment_cubit/like_comment_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/post_like_cubit/post_like_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/share_post_cubit/share_post_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/view_post_screen/share_function_services.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_screen_body_widget.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/fetch_barberdata_repo.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(    create: (context) => FetchPostWithBarberBloc(PostService(FetchBarberRepositoryImpl()))),
        BlocProvider(create: (_) => LikePostCubit()),
        BlocProvider(create: (_) => LikeCommentCubit()),
        BlocProvider(create: (_) => ShareCubit(ShareServicesImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          double heightFactor = 0.5;

          return ColoredBox(
            color: AppPalette.blackClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  isTitle: true,
                  backgroundColor: AppPalette.blackClr,
                  title: 'Posts ˅',
                  iconColor: AppPalette.whiteClr,
                ),
                body: PostScreenWidget(
                    screenHeight: screenHeight,
                    heightFactor: heightFactor,
                    screenWidth: screenWidth),
              ),
            ),
          );
        },
      ),
    );
  }
}
