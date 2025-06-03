import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/models/chat_model.dart';
import '../../../../data/repositories/fetch_chatlebel_data_repo.dart';

part 'last_message_state.dart';

class LastMessageCubit extends Cubit<LastMessageState> {
  final FetchLastmessageRepository _repository;
  StreamSubscription<ChatModel?>? _subscription;

  LastMessageCubit(this._repository) : super(LastMessageInitial());

   lastMessage({required String userId}) async {
    emit(LastMessageLoading());

    _subscription?.cancel();
       final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? barberUid = prefs.getString('barberUid');

    if (barberUid == null) {
      return LastMessageFailure();
    }

    _subscription = _repository
        .latestMessage(userId: userId, barberId: barberUid)
        .listen((chat) {
      if (chat == null) {
        emit(LastMessageFailure());
      } else {
        emit(LastMessageSuccess(chat));
      }
    }, onError: (_) {
      emit(LastMessageFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
