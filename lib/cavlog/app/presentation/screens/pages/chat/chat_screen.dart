import 'package:barber_pannel/cavlog/app/data/repositories/fetch_message_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_chat_userlebel_bloc/fetch_chat_userlebel_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/chat/indivitualchat_screen.dart';
import 'package:barber_pannel/core/common/common_imageshow.dart';
import 'package:barber_pannel/core/common/lottie_widget.dart' show LottiefilesCommon;
import 'package:barber_pannel/core/common/textfield_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/common/custom_app_bar.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/debouncer/debouncer.dart';
import '../../../../../../core/utils/image/app_images.dart';
import '../../../../../../core/validation/input_validations.dart';
import '../../../../data/repositories/fetch_chatlebel_data_repo.dart';
import '../../../../data/repositories/fetch_users_repo.dart';
import '../../../provider/cubit/last_message_cubit/last_message_cubit.dart';
import '../../../provider/cubit/message_badge_cubit/message_badge_cubit.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchChatUserlebelBloc(
          MessageRepositoryImpl(FetchUserRepositoryImpl())),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.blackClr,
            child: Scaffold(
              appBar: CustomAppBar(
                isTitle: true,
                title: 'Chat',
                backgroundColor: AppPalette.blackClr,
                iconColor: AppPalette.whiteClr,
              ),
              body: ChatScreenBodyWidget(
                  screenHeight: screenHeight, screenWidth: screenWidth),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreenBodyWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const ChatScreenBodyWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<ChatScreenBodyWidget> createState() => _ChatScreenBodyWidgetState();
}

class _ChatScreenBodyWidgetState extends State<ChatScreenBodyWidget> {
 final TextEditingController _searchController = TextEditingController();
  late final Debouncer _debouncer;
  @override
  void initState() {
    super.initState();
     _debouncer = Debouncer(milliseconds: 50);
    context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserRequst());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .04),
        child: Column(
          children: [
            TextFormFieldWidget(
              label: '',
              hintText: 'Search shop...',
              prefixIcon: Icons.search,
              controller: _searchController,
              validate: ValidatorHelper.serching,
              borderClr: AppPalette.whiteClr,
              fillClr: AppPalette.whiteClr,
              suffixIconData: Icons.clear,
              suffixIconColor: AppPalette.buttonClr,
              suffixIconAction: () {
              _searchController.clear();
                context.read<FetchChatUserlebelBloc>()
                    .add(FetchChatLebelUserRequst());
              },
              onChanged: (value) {
                _debouncer.run(() {
                  context.read<FetchChatUserlebelBloc>().add(
                        FetchChatLebelUserSearch(value),
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<FetchChatUserlebelBloc, FetchChatUserlebelState>(
              builder: (context, state) {
                if (state is FetchChatUserlebelLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: ListView.builder(
                      itemCount: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatTile(
                          imageUrl: '',
                          shopName: 'Venture Name Loading...',
                          userId: '',
                        );
                      },
                    ),
                  );
                } else if (state is FetchChatUserlebelEmpty ||
                    state is FetchChatUserlebelFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppPalette.buttonClr
                              .withAlpha((0.3 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "⚿ It looks like your chat box is empty! Start a conversation with a client — your chats will appear here. All conversations are private and secure.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppPalette.blackClr),
                        ),
                      )),
                      LottiefilesCommon(
                          assetPath: LottieImages.emptyData,
                          width: widget.screenWidth * 0.3,
                          height: widget.screenHeight * 0.3),
                    ],
                  );
                } else if (state is FetchChatUserlebelSuccess) {
                  final chatList = state.users;

                  return RefreshIndicator(
                    color: AppPalette.buttonClr,
                    backgroundColor: AppPalette.whiteClr,
                    onRefresh: () async {
                      context
                          .read<FetchChatUserlebelBloc>()
                          .add(FetchChatLebelUserRequst());
                    },
                    child: ListView.builder(
                      itemCount: chatList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = chatList[index];
                        return InkWell(
                          onTap: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final String? barberUid =
                                prefs.getString('barberUid');
                            if (barberUid == null) {
                              return;
                            }

                            if (!mounted) return;

                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndividualChatScreen(
                                  barberId: barberUid,
                                  userId: user.uid,
                                ),
                              ),
                            );
                          },
                          child: ChatTile(
                            imageUrl: user.image ?? '',
                            shopName: user.userName ?? 'Unknown User',
                            userId: user.uid,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


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
    final avatarSize = screenWidth * 0.13;
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
        padding: const EdgeInsets.symmetric(vertical: 6),
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
                      fontSize: screenWidth * 0.045,
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
                            fontSize: screenWidth * 0.035,
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
                        return Text(
                          lastMessage,
                          style: TextStyle(
                            color: AppPalette.greyClr,
                            fontSize: screenWidth * 0.035,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return Text(
                        'Tap to view chats',
                        style: TextStyle(
                          color: AppPalette.greyClr,
                          fontSize: screenWidth * 0.035,
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

                      final formattedTime = isLessThan24Hours
                          ? DateFormat('hh:mm a')
                              .format(createdAt) 
                          : DateFormat('dd MMM yyyy')
                              .format(createdAt);
                      return Text(
                        formattedTime,
                        style: TextStyle(
                          color: AppPalette.greyClr,
                          fontSize: screenWidth * 0.03,
                        ),
                      );
                    }
                    return Text(
                      '1 Jan 2000',
                      style: TextStyle(
                        color: AppPalette.greyClr,
                        fontSize: screenWidth * 0.03,
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
