

import 'package:barber_pannel/cavlog/app/data/repositories/fetch_message_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_chat_userlebel_bloc/fetch_chat_userlebel_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_tail_widget.dart/chat_tail_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/custom_app_bar.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../data/repositories/fetch_users_repo.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchChatUserlebelBloc(MessageRepositoryImpl(FetchUserRepositoryImpl())),
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
