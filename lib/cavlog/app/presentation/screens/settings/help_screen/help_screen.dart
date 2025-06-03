
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_needhelp_widget.dart/help_body_widget.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _controller = TextEditingController();
  final bool isUser = true;
  final bool isGemini = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = constraints.maxHeight;
        final double screenWidth = constraints.maxWidth;
        return ColoredBox(
          color: AppPalette.hintClr,
          child: SafeArea(
            child: Scaffold(
                appBar: CustomAppBar(),
                body: DashChatWidget(
                  controller: _controller,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                ),
          ),
        );
      },
    );
  }
}



