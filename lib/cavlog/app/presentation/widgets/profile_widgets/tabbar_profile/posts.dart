
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/delete_post_cubit/delete_post_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/view_post_screen/post_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/profile_widgets/tabbar_profile/tabbar_post/handle_deletepost_state.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../provider/bloc/fetchings/fetch_posts_bloc/fetch_posts_bloc.dart';

class TabbarImageShow extends StatelessWidget {
  const TabbarImageShow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostsBloc, FetchPostsState>(
      builder: (context, state) {
        if (state is FetchPostsLoadingState) {
          return loadingImage();
        } else if (state is FetchPostsEmptyState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.photo_fill_on_rectangle_fill,
                size: 50,
              ),
              ConstantWidgets.hight20(context),
              Text('No posts yet'),
            ],
          ));
         } 
        else if (state is FetchPostSuccessState) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:MediaQuery.of(context).size.width > 600 ? 6 : 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return BlocListener<DeletePostCubit, DeletePostState>(
                listener: (context, deletState) {
                  handleDeletePostsState(context, deletState);
                },
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text(
                          'Are you sure you want to delete or view this post?',
                        ),
                        message: const Text(
                          'If you delete this post, the action cannot be undone. Alternatively, you can view the post details to monitor its progress and status.',
                        ),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              context.read<DeletePostCubit>().deletePost(
                                  barberId: post.barberId,
                                  docId: post.postId);
                              Navigator.pop(context);
                            },
                            isDestructiveAction: true,
                            child: const Text(
                              'Delete for Post',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));

                            },
                            child: const Text(
                              'View Post(s)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppPalette.blackClr,
                              ),
                            ),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppPalette.blackClr,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: imageshow(
                      imageUrl: post.imageUrl,
                      imageAsset: AppImages.loginImageAbove),
                ),
              );
            },
          );
        } 
        
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.cloud_download_fill
              ),
                Text("Oop's Unable to complete the request."),
              Text('Please try again later.'),
            ],
          ));
      
      },
    );
  }

  Shimmer loadingImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? AppPalette.greyClr,
      highlightColor: AppPalette.whiteClr,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.zero,
            ),
            child: Image.asset(
              AppImages.splashImage,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
