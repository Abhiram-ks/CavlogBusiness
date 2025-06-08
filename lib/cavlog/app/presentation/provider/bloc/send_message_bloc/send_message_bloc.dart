
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/cloudinary/cloudinary_service.dart';
import '../../../../data/datasources/firebase_chat_datasource.dart';
import '../../../../data/models/chat_model.dart';
import '../../../../domain/usecases/imageuploadon_cloud_usecase.dart';
part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatRemoteDatasources chatRemoteDatasources;
  final CloudinaryService cloudinaryService;
  final ImageUploader repo;

  SendMessageBloc({
    required this.chatRemoteDatasources,
    required this.cloudinaryService,
    required this.repo,
  }) : super(SendMessageInitial()) {
    on<SendTextMessage>(_onSendTextMessage);
    on<SendImageMessage>(_onSendImageMessage);
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    final now = DateTime.now();
    final message = ChatModel(
      senderId: event.barberId,
      barberId: event.barberId,
      userId: event.userId,
      message: event.message,
      createdAt: now,
      updateAt: now,
      isSee: false,
      delete: false,
      softDelete: false,
    );

    final success = await chatRemoteDatasources.sendMessage(message: message);
    emit(success ? SendMessageSuccess() : SendMessageFailure());
  }

  Future<void> _onSendImageMessage(
    SendImageMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    try {
      
        String? response;
       if (kIsWeb && event.imageBytes != null) {
          response = await cloudinaryService.uploadWebImage(event.imageBytes!);
       } else {
         response  = await repo.upload(event.image);
       } 
      

      if (response == null) {
        emit(SendMessageFailure());
        return;
      }
      

      final now = DateTime.now();
      final message = ChatModel(
        senderId: event.barberId,
        barberId: event.barberId,
        userId: event.userId,
        message: response,
        createdAt: now,
        updateAt: now,
        isSee: false,
        delete: false,
        softDelete: false,
      );

      final success = await chatRemoteDatasources.sendMessage(message: message);
      emit(success ? SendMessageSuccess() : SendMessageFailure());
    } catch (_) {
      emit(SendMessageFailure());
    }
  }
}
