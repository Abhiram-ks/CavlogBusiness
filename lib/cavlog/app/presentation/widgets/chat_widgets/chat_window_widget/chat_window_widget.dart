
import 'package:barber_pannel/cavlog/app/data/models/chat_model.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/request_chatupdate_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/image_picker/image_picker_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/requst_chatstatus_cubit/requst_chatstatus_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/chat_message_buble_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/chat_window_textfiled.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/handle_sendmessage_state.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/image_pick_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatWindowWidget extends StatefulWidget {
  final String userId;
  final String barberId;
  final TextEditingController controller;

  const ChatWindowWidget({
    super.key,
    required this.userId,
    required this.barberId,
    required this.controller,
  });

  @override
  State<ChatWindowWidget> createState() => _ChatWindowWidgetState();
}

class _ChatWindowWidgetState extends State<ChatWindowWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatUpdateCubit = StatusChatRequstDartCubit(RequestForChatupdateRepoImpl());
      chatUpdateCubit.updateChatStatus(
        userId: widget.userId,
        barberId: widget.barberId,
      );
    });
    _scrollController.addListener(_scrollListener);

  }

  void _scrollListener() {
    final isAtBottom = _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 200;

    _shouldAutoScroll = isAtBottom;
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

Stream<List<ChatModel>> getMessagesStream() {
  return FirebaseFirestore.instance
      .collection('chat')
      .where('userId', isEqualTo: widget.userId)
      .where('barberId', isEqualTo: widget.barberId)
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => ChatModel.fromMap(doc.id, doc.data()))
            .toList();
      });
}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<ChatModel>>(
            stream: getMessagesStream(),
            builder: (context, snapshot) {
              final messages = snapshot.data ?? [];
              if (_shouldAutoScroll) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });
              }
              if (snapshot.hasData && _scrollController.hasClients) {
                 WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
              }
  
              if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
              }

              if (messages.isEmpty) {
               return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      ConstantWidgets.hight50(context),
                      Center(
                          child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppPalette.buttonClr.withAlpha((0.3 * 255).round()),
                          borderRadius: BorderRadius.circular(12), 
                          ),
                        child: Text(
                           '⚿ No conversations yet.Your chats are private and end-to-end encrypted. Only you and your barber can read them. Start a conversation now and enjoy seamless, secure messaging!',

                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppPalette.blackClr),
                        ),
                      )),
                    ],
                  );
              }
              
              return ListView.builder(
                
                controller: _scrollController,
                itemCount: messages.length,
                padding:  EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width*0.15 :MediaQuery.of(context).size.width*0.01),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final bool showDateLabel = index == 0 ||  messages[index - 1].createdAt.day != message.createdAt.day;

                  return Column(
                    children: [
                      if (showDateLabel)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppPalette.hintClr,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                DateFormat('dd MMM yyyy').format(message.createdAt),
                                style:const TextStyle(color: AppPalette.whiteClr),
                              ),
                            ),
                          ),
                        ),
                      MessageBubleWidget(
                        message: message.message,
                        time: DateFormat('hh:mm a').format(message.createdAt),
                        isCurrentUser: message.senderId == widget.barberId,
                        docId: message.docId ?? '',
                        delete:  message.delete == true,
                        softDelete:message.senderId == widget.barberId && message.softDelete == true,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        imagePIckerChating(),
        BlocListener<SendMessageBloc, SendMessageState>(
          listener: (context, state) {
            handleSendMessage(context, state, widget.controller);
          },
          child: ChatWindowTextFiled(
            controller: widget.controller,
            sendButton: () {
              final text = widget.controller.text.trim();
              final imageState = context.read<ImagePickerBloc>().state;

              if (imageState is ImagePickerSuccess) {
                context.read<SendMessageBloc>().add(SendImageMessage(
                    image: imageState.imagePath ?? '',
                    imageBytes:kIsWeb ?  imageState.imageBytes : null,
                    userId: widget.userId,
                    barberId: widget.barberId));
              }
              if (text.isEmpty) return;

              context.read<SendMessageBloc>().add(
                    SendTextMessage(
                      message: text,
                      userId: widget.userId,
                      barberId: widget.barberId,
                    ),
                  );
              Future.delayed(const Duration(milliseconds: 1), () {
                scrollToBottom();
              });
            },
          ),
        ),
      ],
    );
  }
}

