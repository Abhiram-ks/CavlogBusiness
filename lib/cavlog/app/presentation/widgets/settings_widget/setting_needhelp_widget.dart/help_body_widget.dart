
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/gemini_chat_bloc/gemini_chat_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/chat_window_textfiled.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_needhelp_widget.dart/help_promit_chatbuilder.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DashChatWidget extends StatelessWidget {
  final TextEditingController controller;
  final double screenHeight;
  final double screenWidth;
  const DashChatWidget(
      {super.key,
      required this.controller,
      required this.screenHeight,
      required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Assistant',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                'There are no limits to what you can accomplish, except the limits you place on your own thinking. Any problem can be solved with the right mindset and approach.',
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        HelpPromitChatBuilder(),
        ChatWindowTextFiled(
          controller: controller,
          isICon: false,
          sendButton: () {
            final text = controller.text.trim();
          
            if (text.isNotEmpty) {
              context.read<GeminiChatBloc>().add(SendGeminiMessage(text));
              controller.clear();
            }
          },
        )
      ],
    );
  }
}
