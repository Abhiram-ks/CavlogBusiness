
import 'package:barber_pannel/cavlog/app/data/models/comment_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_comment_repo.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/data_listing_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_comments_bloc/fetch_comments_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/like_comment_cubit/like_comment_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_comment_custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';

void showCommentSheet({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String barberId,
  required String docId,
  required TextEditingController commentController,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppPalette.scafoldClr,
    enableDrag: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      // This is needed to adjust for keyboard height when it appears
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return MultiBlocProvider(
        providers: [
          BlocProvider<FetchCommentsBloc>(
            create: (context) {
              final bloc = FetchCommentsBloc(SendCommentRepositoryImpl());
              bloc.add(FetchCommentRequst(docId: docId));
              return bloc;
            },
          ),
          BlocProvider<LikeCommentCubit>(
            create: (_) => LikeCommentCubit(),
          ),
        ],
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: screenHeight,
            child: Column(
              children: [
                ConstantWidgets.hight10(context),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ConstantWidgets.hight10(context),
                Expanded(
                  child: BlocBuilder<FetchCommentsBloc, FetchCommentsState>(
                    builder: (context, state) {
                      if (state is FetchCommentsLoading) {
                        return Center(child: Text('Loading...'));
                      }
                      if (state is FetchCommentsSuccess) {
                        return ListView.separated(
                          itemCount: state.comments.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final CommentModel comment = state.comments[index];
                            final formattedDate = formatDate(comment.createdAt);
                            final formattedStartTime =  formatTimeRange(comment.createdAt);
                            return commentListWidget(
                                createdAt: '$formattedDate At $formattedStartTime',
                                favoriteColor:
                                    comment.likes.contains(state.barberID)
                                        ? AppPalette.redClr
                                        : AppPalette.blackClr,
                                favoriteIcon:
                                    comment.likes.contains(state.barberID)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                likesCount: comment.likes.length,
                                likesOnTap: () {
                                  context.read<LikeCommentCubit>().toggleLike(
                                    barberId: barberId,
                                      docId: comment.docId,
                                      currentLikes: comment.likes);
                                },
                                context: context,
                                userName: comment.userName,
                                comment: comment.description,
                                imageUrl: comment.imageUrl);
                          },
                          separatorBuilder: (context, index) =>
                              ConstantWidgets.hight10(context),
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstantWidgets.hight50(context),
                            Center( child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppPalette.buttonClr
                                    .withAlpha((0.3 * 255).round()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                              "💬 No comments yet. Others can share their thoughts here.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppPalette.blackClr),
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
