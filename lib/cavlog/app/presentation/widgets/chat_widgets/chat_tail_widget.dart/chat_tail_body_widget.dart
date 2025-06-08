import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_chat_userlebel_bloc/fetch_chat_userlebel_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/chat/indivitualchat_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_tail_widget.dart/chat_tail_custom_widget.dart';
import 'package:barber_pannel/core/common/lottie_widget.dart';
import 'package:barber_pannel/core/common/textfield_helper.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/debouncer/debouncer.dart';
import 'package:barber_pannel/core/utils/image/app_images.dart';
import 'package:barber_pannel/core/validation/input_validations.dart' show ValidatorHelper;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
        padding: EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *0.3 : widget.screenWidth * .04),
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
              context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserRequst());
              },
              onChanged: (value) {
                _debouncer.run(() {
                  context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserSearch(value));
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
                          color: AppPalette.buttonClr.withAlpha((0.3 * 255).round()),
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
                      context.read<FetchChatUserlebelBloc>().add(FetchChatLebelUserRequst());
                    },
                    child: ListView.builder(
                      itemCount: chatList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = chatList[index];
                        return InkWell(
                          focusColor: AppPalette.buttonClr,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndividualChatScreen(
                                  barberId: state.barberId,
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

