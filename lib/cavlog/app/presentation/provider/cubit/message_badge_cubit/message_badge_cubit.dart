import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/repositories/fetch_chatlebel_data_repo.dart';

part 'message_badge_state.dart';

class MessageBadgeCubit extends Cubit<MessageBadgeState> {
  final FetchLastmessageRepository _repository;
  StreamSubscription<int>? _subscription;

  MessageBadgeCubit(this._repository) : super(MessageBadgeInitial());

  numberOfBadges({
    required String userId,
  }) async {
    emit(MessageBadgeLoading());

    _subscription?.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? barberUid = prefs.getString('barberUid');

    if (barberUid == null) {
      return MessageBadgeFailure();
    }
    _subscription = _repository
        .messageBadges(userId: userId, barberId: barberUid)
        .listen((count) {
      if (count == 0) {
        emit(MessageBadgeEmpty());
      } else {
        emit(MessageBadgeSuccess(count));
      }
    }, onError: (_) {
      emit(MessageBadgeFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
