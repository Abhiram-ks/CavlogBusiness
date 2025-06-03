import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/like_animation_cubit/like_animation_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_card_maker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreenMainWidget extends StatelessWidget {
  final double screenHeight;
  final double heightFactor;
  final double screenWidth;
  final String postUrl;
  final String shopUrl;
  final String shopName;
  final String location;
  final int likes;
  final String description;
  final VoidCallback profilePage;
  final VoidCallback likesOnTap;
  final VoidCallback shareOnTap;
  final VoidCallback commentOnTap;
  final Color favoriteColor;
  final IconData favoriteIcon;
  final String dateAndTime;
  final bool isLiked;

  const PostScreenMainWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
    required this.postUrl,
    required this.shopUrl,
    required this.shopName,
    required this.location,
    required this.likes,
    required this.description,
    required this.profilePage,
    required this.likesOnTap,
    required this.shareOnTap,
    required this.favoriteColor,
    required this.favoriteIcon,
    required this.dateAndTime,
    required this.commentOnTap, required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (_) => PostLikeAnimationCubit(),
      child: PostgScreenGenerateWIdget(
          profilePage: profilePage,
          shopUrl: shopUrl,
          shopName: shopName,
          location: location,
          isLiked: isLiked,
          likesOnTap: likesOnTap,
          screenHeight: screenHeight,
          heightFactor: heightFactor,
          postUrl: postUrl,
          favoriteIcon: favoriteIcon,
          favoriteColor: favoriteColor,
          shareOnTap: shareOnTap,
          commentOnTap: commentOnTap,
          screenWidth: screenWidth,
          likes: likes,
          description: description,
          dateAndTime: dateAndTime),
    );
  }
}
