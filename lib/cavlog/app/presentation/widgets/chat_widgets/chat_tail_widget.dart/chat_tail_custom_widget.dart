import 'package:barber_pannel/cavlog/app/data/repositories/fetch_chatlebel_data_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/last_message_cubit/last_message_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/message_badge_cubit/message_badge_cubit.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String userId;

  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = 50.00;
    final horizontalSpacing = screenWidth * 0.04;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = MessageBadgeCubit(FetchLastmessageRepositoryImpl());
            cubit.numberOfBadges(userId: userId);
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = LastMessageCubit(FetchLastmessageRepositoryImpl());
            cubit.lastMessage(userId: userId);
            return cubit;
          },
        ),
      ],
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 3, horizontal: screenWidth*0.04),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: imageshow(
                  imageUrl: imageUrl,
                  imageAsset: AppImages.loginImageAbove,
                ),
              ),
            ),
            SizedBox(width: horizontalSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<LastMessageCubit, LastMessageState>(
                    builder: (context, state) {
                      if (state is LastMessageLoading) {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            color: AppPalette.greyClr,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else if (state is LastMessageSuccess) {
                        final message = state.message;
                        String lastMessage = message.message;

                        if (message.delete) {
                          lastMessage = 'This message was deleted';
                        }
                        if(lastMessage.startsWith('http')) {
                           lastMessage = 'Message Files(image/doc/link...)';
                        }
                        return Text(
                          lastMessage,
                          style: TextStyle(
                            color: AppPalette.greyClr,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return Text(
                        'Tap to view chats',
                        style: TextStyle(
                          color: AppPalette.greyClr,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: horizontalSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<LastMessageCubit, LastMessageState>(
                  builder: (context, state) {
                    if (state is LastMessageSuccess) {
                      final DateTime createdAt = state.message.createdAt;
                      final DateTime now = DateTime.now();
                      final bool isLessThan24Hours =  now.difference(createdAt).inHours < 24;

                      final formattedTime = isLessThan24Hours? DateFormat('hh:mm a').format(createdAt): DateFormat('dd MMM yyyy').format(createdAt);
                      return Text(
                        formattedTime,
                        style: TextStyle(
                          color: AppPalette.greyClr,
                        ),
                      );
                    }
                    return Text(
                      '1 Jan 2000',
                      style: TextStyle(
                        color: AppPalette.greyClr,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                BlocBuilder<MessageBadgeCubit, MessageBadgeState>(
                  builder: (context, state) {
                    if (state is MessageBadgeSuccess) {
                      final int badges = state.badges;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: avatarSize * 0.12,
                          vertical: avatarSize * 0.05,
                        ),
                        decoration: const BoxDecoration(
                          color: AppPalette.orengeClr,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badges.toString(),
                          style: TextStyle(
                            color: AppPalette.whiteClr,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
