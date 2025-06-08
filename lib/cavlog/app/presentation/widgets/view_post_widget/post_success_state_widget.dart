
import 'package:barber_pannel/cavlog/app/data/models/post_with_barber.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_postwith_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/post_like_cubit/post_like_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/share_post_cubit/share_post_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_bottom_sheet.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_card_widget.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/colors.dart';

RefreshIndicator postBlocSuccessStateBuilder(
    {required BuildContext context,
    required List<PostWithBarberModel> model,
    required FetchPostWithBarberLoaded state,
    required double screenHeight,
    required double screenWidth,
    required double heightFactor,
    required TextEditingController commentController}) {
  return RefreshIndicator(
    color: AppPalette.buttonClr,
    backgroundColor: AppPalette.whiteClr,
    onRefresh: () async {
      context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequest());
    },
    child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (context, index) {
        final data = model[index];
        final formattedDate = formatDate(data.post.createdAt);
        final formattedStartTime = formatTimeRange(data.post.createdAt);

        return PostScreenMainWidget(
          screenHeight: screenHeight,
          heightFactor: heightFactor,
          screenWidth: screenWidth,
          shopName: data.barber.ventureName,
          description: data.post.description,
          isLiked: data.post.likes.contains(state.barberId),
          favoriteColor: data.post.likes.contains(state.barberId)
              ? AppPalette.redClr
              : AppPalette.blackClr,
          favoriteIcon: data.post.likes.contains(state.barberId)
              ? Icons.favorite
              : Icons.favorite_border,
          likes: data.post.likes.length,
          location: data.barber.address,
          postUrl: data.post.imageUrl,
          shopUrl: data.barber.image ?? AppImages.loginImageAbove,
          shareOnTap: () {
            context.read<ShareCubit>().sharePost(
                  text: data.post.description,
                  ventureName: data.barber.ventureName,
                  location: data.barber.address,
                  imageUrl: data.post.imageUrl,
                );
          },
          commentOnTap: () {
            showCommentSheet(
              context: context,
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              barberId: data.barber.uid,
              docId: data.post.postId,
              commentController: commentController,
            );
          },
          likesOnTap: () {
            context.read<LikePostCubit>().toggleLike(
                  barberId: data.barber.uid,
                  postId: data.post.postId,
                  currentLikes: data.post.likes,
                );
          },
          profilePage: () {
          },
          dateAndTime: '$formattedDate at $formattedStartTime',
        );
      },
      separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
    ),
  );
}
